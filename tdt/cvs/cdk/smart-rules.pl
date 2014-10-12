#!/usr/bin/perl
use strict;
use warnings;
use IO::File;
use constant DEBUG => 0;

# input makefile for processing
my $filename = shift;

my $package = ""; # current processing package
my $target; # base .deps file for current processing package
my $version; # version of current processing package
my $dir; # dir for current processing package

# function and call commands staff
my %functions = (); # list of all defined functions.
my $function = "";  # current function

my $line = 0; # processing line, for debug

# command sytax definitions
my $supported_protocols = "https|http|ftp|file|git|svn|local|localwork";
# commands executed at prepare time
my $make_commands = "nothing|extract|dirextract|patch(-(\\d+))?|pmove|premove|plink|pdircreate|plndir";
# commands executed at install time
my $install_commands = "install|install_file|install_bin|make|move|remove|mkdir|link";
# pattern that will be substituted
my $P = "\${P}";

sub load ($$);

my %bracket = (
  "rule" => 0,
  "package" => 0,
  "function" => 0,
);
my @lastbracket = ();

# syntax checks
sub begin($)
{
  my $br = shift;
  print "> open $br\n" if DEBUG;
  push @lastbracket, $br;
  if ($bracket{$br} == 1) {
    die "recursive $_ is forbidden";
  } else {
    $bracket{$br} = 1;
  }
}

sub end($)
{
  my $br = shift;
  print "< close $br\n" if DEBUG;
  my $bl = pop @lastbracket;
  if ($bl ne $br) { die "mismatch $bl closure bracket"; }
  if ($bracket{$br} == 0) {
    die "mismatch $_ closure bracket"
  } else {
    $bracket{$br} = 0;
  }
}

# File preprocessor begins.
sub load ($$)
{
  my ( $filename, $ignore ) = @_;

  my $fh = new IO::File $filename;

  if ( ! $fh )
  {
    return undef if $ignore;
    die "can't open $filename\n";
  }

  my $foutname;
  ($foutname = $filename) =~ s#(.*).pre#$1#;
  print "output to $foutname\n";
  open FILE, "+>", "$foutname";

  while ( <$fh> )
  {
    $line += 1;

    # === rule brackets ===
    if ( $_ =~ m#^\]\]rule\s*$# )
    {
      end("rule");
      next;
    }
    if ( $_ =~ m#^rule\[\[\s*$# )
    {
      begin("rule");
      next;
    }

    # === package brackets ===
    if ($_ =~ m#^package\[\[# )
    {
      if ( $_ =~ m#^package\[\[\s*([\w_]+)\s*$# ) {
        begin("package");
        $package = $1;
        print "==> $package" . "\n" if DEBUG;
        process_begin();
        next;
      } else {
        die "$line: bad package[[ command format: " . $_;
      }
    }
    if ( $_ =~ m#^\]\]package# )
    {
      end("package");
      $package = "";
      next;
    }

    # === function brackets ===
    if ($_ =~ m#^function\[\[# )
    {
      if ( $_ =~ m#^function\[\[\s*([\w_]+)\s*$# ) {
        begin("function");
        $function = $1;
        $functions{$1} = "";
        print "==> $function" . "\n" if DEBUG;
        output("### function $function\n");
        next;
      } else {
        die "$line: bad function[[ command format: " . $_;
      }
    }
    if ( $_ =~ m#^\]\]function# )
    {
      output("### end function\n");
      end("function");
      $function = "";
      next;
    }

    # === call command ===
    if ( $_ =~ m#^call\[\[\s*([\w_]+)\s*\]\]# )
    {
      if (defined $functions{$1}) {
        output($functions{$1});
      } else {
        die "unknown function $1";
      }
      next;
    }

    #don't touch Makefile conditional in rule[[
    if ($bracket{"rule"} != 1 or ($_ =~ m#^(ifdef |ifndef |ifeq |ifneq |else|endif)#) )
    {
      output($_);
      next;
    }
    # === rule preprocessor begin ==

    # remove comments
    $_ =~ s/#.*$//;
    # skip empty lines
    if ($_ =~ m#^\s+$#) {
      next;
    }
    chomp $_;
    $_ =~ s/^\s+//; #remove leading spaces
    $_ =~ s/\s+$//; #remove trailing spaces

    process_block($_);

  }
  print "lines $line\n" if DEBUG;
  close FILE;
}

sub process_block ($)
{
  warn "==> $package, $version, $dir  :  $_" if DEBUG;
  my $out;

  process_depends($_);
  $out = process_prepare($_);
  output("PREPARE_$P += $out \n") if $out;
  $out = process_sources($_);
  output("SRC_URI_$P += $out \n") if $out;
  $out = process_install($_);
  output("INSTALL_$P += $out \n") if $out;
  $out = process_download($_);
  output("$out \n") if $out;

  output("\n");
}

sub process_rule($) {

  warn "parse: " . $_ . "\n" if DEBUG;

  my $f = ""; # file from url
  my $l = $_;
  my @l = (); # input list

  if ($l =~ m#\;#)
  {
    @l = split( /;/ , $l );
  } else {
    @l = split( m#:(?!//)# , $l );
  }

  my $protocol = "none";
  my $url = "";
  my $foundurl = 0;
  my @cmd_argv = ();
  my @url_argv = ();
  my $arg;
  while ($arg = shift @l)
  {
    if ( $arg =~ m#^($supported_protocols)://# ) {
      $protocol = $1;
      $url = $arg;
      $foundurl = 1;
      next;
    }
    if($foundurl == 1) {
      push(@url_argv, $arg);
    } else {
      push(@cmd_argv, $arg);
    }
  }
  my $cmd = shift @cmd_argv;
  if (defined($cmd)) {
    if ( $cmd !~ m#^($make_commands|$install_commands)$# ) {
      die "$line: can't recognize command $cmd";
    }
  } else {
    $cmd = "extract";
  }

  if ( $protocol ne "none" )
  {
    my @a = split("/", $url);
    $f = $a[-1];
  }

  my %args = ();
  my @argv = ();

  while(my $arg = shift @url_argv)
  {
    # argument dict
    if ($arg =~ m/(\w+)=(.*)/)
    {
      $args{$1} = $2 ;
      #warn "arg " . $1 . ' = ' . $2 . "\n";
    } else {
    # argument list
      push(@argv, $arg);
      #warn "argv " . $arg . "\n";
    }
  }

  if ($url) {
    if ( $url =~ m#^svn://# )
    {
        $f = $P . ".svn"
    }
    if ( $url =~ m#^file://# )
    {
        $f = $url;
        $f =~ s#^file://##;
        $f = "\$(SDIR_$P)/$f";
    }
    elsif ( $url =~ m#^localwork://# )
    {
        $f = $url;
        $f =~ s#^localwork://##;
    }
    elsif ( $url =~ m#^($supported_protocols)://# )
    {
        $f = "\$(archivedir)/$f";
    }
  }

  my $urldbg = $url;
  if (not $urldbg) { $urldbg = "none" };
  warn "command $cmd; argv @cmd_argv; url $url; protocol: $protocol; file: $f;\n" if DEBUG;

  return ($protocol, $f, $cmd, $url, \%args, \@cmd_argv, \@argv);
}


sub process_depends ($)
{
    my ($p, $f) = process_rule($_);
    return if ( $p eq "none" || $p eq "localwork");

    if ( $p =~ m#^(file)$# ) {
      # Oder-only dependencies. Don't check file timestamp, only check if it exists.
      output("$target.do_prepare: | $f \n");
    }
    elsif( $p =~ m#^($supported_protocols)$# ) {
      output("$target.do_prepare: $f \n");
    }
    else {
      die "can't recognize protocol " . $p;
    }
}

sub process_begin ()
{
  # some common variables
  $target  = "\$(TARGET_$P)";
  $dir = "\$(DIR_$P)";
  $version = "\$(PV_$P)";

=pod
  my $output;
  # make it safe. rm -rf
  $output .= "DIR_$package := \$(if $dir,\$(workprefix)/$dir,\$(workprefix)/$package)" . "\n";

  $output .= "PREPARE_$package = ( rm -rf $dir || /bin/true )" . "\n";
  $output .= "INSTALL_$package = /bin/true" . "\n";
  $output .= "DEPENDS_$package = $targetbase.version_\$(PKGV_$package)-\$(PKGR_$package)" . "\n";
  # remove previous versions so, if you change version back to the previous value it cause rebuild again.
  $output .= "UPDATE_$package = rm -rf $targetbase.version*" . "\n";

  if ($version =~ m#^git|svn$#) {
    my $ret = process_update($version, $dir);
    # in case package is in local sources
    $output .= "UPDATE_$package += && ($ret)" . "\n";
    # list of packages to check for vcs updates
    $output .= "UPDATE_LIST += $targetbase.version_\$(PKGV_$package)-\$(PKGR_$package)" . "\n";
    # get version from vcs
    $output .= "AUTOPKGV_$package = \$(eval export PKGV_$package = \$(shell cd $dir && \$(${version}_version)))" . "\n";
  } else {
    $output .= "UPDATE_$package += && touch \$\@" . "\n";
  }

  $output .= "\n";
  $output .= "$targetbase.version_%:"    . "\n";
  $output .= "\t\$(UPDATE_$package)" . "\n";

  $output .= "\n";
  $output .= "$target.clean_prepare:"      . "\n";
  $output .= "\trm -f $target.do_prepare"  . "\n";
  $output .= "$target.clean_compile:"      . "\n";
  $output .= "\trm -f $target.do_compile"  . "\n";
  $output .= "$target.clean:"              . "\n";
  $output .= "\trm -f $target"             . "\n";

  $output .= "\n";
  output($output);
=cut
}


sub process_prepare ($)
{

  my $output = "";
  my $outpost = "";

    my ($p, $f, $cmd, $url, $opts_ref, $argv_ref) = process_rule($_);
    my %opts = %$opts_ref;
    my @args = @$argv_ref;

    # $args[0] equals $cmd.
    unshift(@args, $cmd);

    my $subdir = "";
    $subdir = "/" . $opts{"sub"} if $opts{"sub"};

    if ( $cmd !~ m#^($make_commands)$# )
    {
      return;
    }

    $output .= "&& cd \$(WORK_$P) && ";

    if ( ($cmd eq "extract" or $cmd eq "dirextract") and $p !~ m#(git|svn)#)
    {
      if ( $cmd eq "dirextract" ) {
        $output .= "( mkdir $dir || /bin/true ) && ";
        $output .= "( cd $dir; ";
      }
      if ( $f =~ m#\.tar\.bz2$# )
      {
        $output .= "bunzip2 -cd " . $f . " | tar -x";
      }
      elsif ( $f =~ m#\.tar\.gz$# )
      {
        $output .= "gunzip -cd " . $f . " | TAPE=- tar -x";
      }
      elsif ( $f =~ m#\.tgz$# )
      {
        $output .= "gunzip -cd " . $f . " | TAPE=- tar -x";
      }
      elsif ( $f =~ m#\.tar\.xz$# )
      {
      $output .= "tar -xJf " . $f;
      }
      elsif ( $f =~ m#\.exe$# )
      {
        $output .= "cabextract " . $f;
      }
      elsif ( $f =~ m#\.zip$# )
      {
        $output .= "unzip " . $f;
      }
      elsif ( $f =~ m#\.(src|sh4)\.rpm$# )
      {
        $output .= "rpm2cpio " . $f . " | cpio -dimv ";
      }
      else
      {
        die "can't recognize type of archive \"$f\"";
      }
      if ( $cmd eq "dirextract" ) {
        $output .= " )";
      }
    }
    elsif ( $p eq "svn" )
    {
      # -- set SVN_DIR variable
      $outpost .= "SVN_DIR_$P = $f \n";
	  
      # -- pull changes from server
      # cd repo
      my $upd .= "cd $f";
      # update
      if ($opts{"r"}) {
        $upd .= " && svn update -r " . $opts{"r"};
      } else {
	    $upd .= " && svn update";
      }
      $upd .= " && cd -";
      $outpost .= "UPDATE_$P := $upd \n";
	  
      # -- copy repo to work dir
      $output .= "cp -a $f/$subdir $dir";
    }
    elsif ( $p eq "git" )
    {
      my $branch = "master";
      my $rev;
      $branch = $opts{"b"} if $opts{"b"};
      $rev = $opts{"r"} if $opts{"r"};

      # -- set GIT_DIR variable
      $outpost .= "GIT_DIR_$P = $f \n";

      # -- pull changes from remote --
      my $upd = "";
      # create git url with protocol
      my $tmpurl = $url;
      $tmpurl =~ s#git://#$opts{"protocol"}://#  if $opts{"protocol"} ;
      $tmpurl =~ s#ssh://#git\@# if $opts{"protocol"} and $opts{"protocol"} eq "ssh";
      # сd git directory
      $upd .= "cd $f && ";
      # check if url has changed
      $upd .= "(test \"`git config --get remote.origin.url`\" == \"$tmpurl\"";
      $upd .= " || git remote set-url origin $tmpurl)";
      # fetch remote chages
      $upd .= " && git fetch";
      # checkout git tree
      if (not $rev) {
        $upd .= " && git checkout origin/$branch";
      } else {
        $upd .= " && git checkout $rev";
      }
      # exit git dir
      $upd .= " && cd -";
      $outpost .= "UPDATE_$P := $upd \n";

      # -- copy git tree to working dir --
      $output .= "cp -a $f/$subdir $dir";
    }
    elsif ( $cmd eq "nothing" )
    {
      $output .= "cp -a $f $dir";
    }
    elsif ( $cmd =~ m/patch(-(\d+))?/ )
    {
      shift @args;
      my $patch;
      if ($2) {
        $patch = "patch -p$2 ";
      } else {
        $patch = "patch -p1 ";
      }
      $patch .= join " ", @args;
      # we want make to throw error in case "unzip | patch" fails on uzip command
      $patch = "($patch && exit \$\${PIPESTATUS[0]})";

      if ( $f =~ m#\.bz2$# )
      {
        $output .= "( cd $dir && chmod +w -R . && bunzip2 -cd $f | $patch )";
      }
      elsif ( $f =~ m#\.deb\.diff\.gz$# )
      {
        $output .= "( cd $dir && gunzip -cd $f | $patch )";
      }
      elsif ( $f =~ m#\.gz$# )
      {
        $output .= "( cd $dir && chmod +w -R . && gunzip -cd  $f | $patch )";
      }
      elsif ( $f =~ m#\.spec\.diff$# )
      {
        $output .= "( cd SPECS && $patch <  $f )";
      }
      else
      {
        $output .= "( cd $dir && chmod +w -R . && $patch <  $f )";
      }
    }
    elsif ( $cmd eq "pmove" )
    {
      $output .= "mv " . $args[1] . " " . $args[2];
    }
    elsif ( $cmd eq "premove" )
    {
      $output .= "( rm -rf " . $args[1] . " || /bin/true )";
    }
    elsif ( $cmd eq "plink" )
    {
      $output .= "( ln -sf " . $args[1] . " " . $args[2] . " || /bin/true )";
    }
    elsif ( $cmd eq "plndir" )
    {
      $output .= "lndir " . $args[1] . " " . $args[2];
    }
    elsif ( $cmd eq "pdircreate" )
    {
      $output .= "( mkdir -p " . $args[1] . " )";
    }
    else
    {
      die "can't recognize command $cmd";
    }

  $output .= "\n$outpost" if $outpost;
  return $output;
}

sub process_update ($$)
{
  my ( $vcs, $d ) = @_;
  my $out;
  # if directory exists launch touch command, return 1 if command failed
  # if directory doesn't exists return 0
  $out = "[ ! -d $d ] || (touch \$\@ -d `cd $d && \$(${vcs}_version_time)` && echo \$\@: `date -r \$\@`)";
  return $out;
}

sub process_install ($)
{

  my ($p, $f, $cmd, $url, $opts_ref, $argv_ref) = process_rule($_);
  my @argv = @$argv_ref;

  if ( $cmd !~ m#^($install_commands)$# )
  {
    return;
  }

  my $output = "&& ";

  if ( $cmd =~ m#install_file|install_bin# )
  {
    $cmd =~ y/a-z/A-Z/ ;
    $output .= "\$\($cmd\) $f @argv";
  }
  elsif ( $cmd eq "make" )
  {
    $output .= "\$\(MAKE\) " . join " ", @argv;
  }
  elsif ( $cmd eq "install" )
  {
    if($f ne "") {
      $output .= "\$\(INSTALL\) $f " . join " ", @argv;
    } else {
      $output .= "\$\(INSTALL\) " . join " ", @argv;
    }
  }
  elsif ( $cmd eq "move" )
  {
    $output .= "mv " . join " ", @argv;
  }
  elsif ( $cmd eq "remove" )
  {
    $output .= "rm -rf " . join " ", @argv;
  }
  elsif ( $cmd eq "mkdir" )
  {
    $output .= "mkdir -p " . join " ", @argv;
  }
  elsif ( $cmd eq "link" )
  {
    $output .= "ln -sf " . join " ", @argv;
  }
=pod
  elsif ( $cmd =~ m/^rewrite-(libtool|pkgconfig|dependency)/ )
  {
    $output .= "perl -pi -e \"s,^libdir=.*\$\$,libdir='TARGET/usr/lib',\" ". join " ", @argv if $1 eq "libtool";
    $output .= "perl -pi -e \"s, /usr/lib, TARGET/usr/lib,g if /^dependency_libs/\"  ". join " ", @argv if $1 eq "dependency";
    $output .= "perl -pi -e \"s,^prefix=.*\$\$,prefix=TARGET/usr,\" " . join " ", @argv if $1 eq "pkgconfig";
  }
=cut
  else
  {
    die "can't recognize rule \"$cmd\"";
  }

  return $output;
}

=pod
sub process_uninstall_rule ($)
{
  my $rule = shift;
  my ($p, $f, $cmd) = process_rule($rule);
  
  if ( $cmd =~ m#$make_commands# )
  {
    return "";
  }

  @_ = split ( /:/, $rule );
  $_ = shift @_;

  my $output = "";

  if ( $_ eq "make" )
  {
    $output .= "\$\(MAKE\) " . join " ", @_;
  }
  elsif ( $_ eq "install" )
  {
    $output .= "\$\(INSTALL\) " . join " ", @_;
  }
  elsif ( $_ eq "rpminstall" )
  {
    $output .= "rpm \${DRPM} --ignorearch -Uhv RPMS/sh4/" . join " ", @_;
  }
  elsif ( $_ eq "shellconfigdel" )
  {
    $output .= "export HCTDUNINST \&\& HOST/bin/target-shellconfig --del " . join " ", @_;
  }
  elsif ( $_ eq "initdconfigdel" )
  {
    $output .= "export HCTDUNINST \&\& HOST/bin/target-initdconfig --del " . join " ", @_;
  }
  elsif ( $_ eq "move" )
  {
    $output .= "mv " . join " ", @_;
  }
  elsif ( $_ eq "remove" )
  {
    $output .= "rm -rf " . join " ", @_;
  }
  elsif ( $_ eq "link" )
  {
    $output .= "ln -sf " . join " ", @_;
  }
  elsif ( $_ eq "archive" )
  {
    $output .= "TARGETNAME-ar cru " . join " ", @_;
  }
  elsif ( $_ =~ m/^rewrite-(libtool|pkgconfig)/ )
  {
    $output .= "perl -pi -e \"s,^libdir=.*\$\$,libdir='TARGET/lib',\"  ". join " ", @_ if $1 eq "libtool";
    $output .= "perl -pi -e \"s,^prefix=.*\$\$,prefix=TARGET,\" " . join " ", @_ if $1 eq "pkgconfig";
  }
  else
  {
    die "can't recognize rule \"$rule\"";
  }

  return $output;
}
=cut

sub process_sources ($)
{
  my $output = "";

    my ($p, $f, $cmd, $url, $opts_ref) = process_rule($_);
    my %opts = %$opts_ref;
    return if ( $p eq "none" );
    my $rev = "";
    $rev = ":r$opts{'r'}" if $opts{"r"};
    $output .= "$url$rev ";

  return "$output"
}

sub process_download ($)
{
    my $output = "";

    my ($p, $f, $cmd, $url, $opts_ref) = process_rule($_);
    my %opts = %$opts_ref;
    return if ( $p eq "file" || $p eq "none" || $p eq "local" || $p eq "localwork");

    $f =~ s/\\//;

    my $file = $f;
    $file =~ s/\$\(archivedir\)//;

    # Check if we already have rule for fetching this file
    # sorry for gnu make magic...
    $output .= "ifeq (\$(filter $f,\$(_all_download)),\$(empty))\n";
    # add file to known list
    $output .= "_all_download += $f\n";
    $output .= "$f:\n";

    my $mirror = "\$(WGET_MIRROR)";

    if ( $url =~ m#^(ftp|http|https)://# )
    {
      $output .= "\t\$(WGET) \$(archivedir) $url || \$(WGET) \$(archivedir) $mirror/$file";
    }
    elsif ( $url =~ m#^svn://# )
    {
      my $tmpurl = $url;
      $url =~ s#svn://#http://# ;
      $output .= "\tsvn checkout $url $f";
    }
    elsif ( $url =~ m#^git://# )
    {
      my $tmpurl = $url;
      $tmpurl =~ s#git://#$opts{"protocol"}://#  if $opts{"protocol"} ;
      $tmpurl =~ s#ssh://#git\@# if $opts{"protocol"} and $opts{"protocol"} eq "ssh";
      $output .= "\tgit clone $tmpurl  $f";
      $output .= " -b " . $opts{"b"} if $opts{"b"};
    }
    $output .= "\n";
    $output .= "endif\n";
    # end Check
    return "$output"
}


sub output($)
{
  my $output = shift;
  if ($package ne "") {
    # $$ escapes $
    # Replace ${P} with package
    $output =~ s/(?<!\$)\${P}/$package/g;
    # Replace ${VARIABLE} with $(VARIABLE_package)
    $output =~ s/(?<!\$)\${([\w\d_]+)}/\$\($1_$package\)/g;
  }

  if ($function ne "") {
    $functions{$function} .= $output;
  } else {
    print FILE $output;
  }
}

load ( $filename, 0 );
