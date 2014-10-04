Smart-rules
===========
These rules are smarter ;)

rules are separated by line break
all trailing white-spaces are ignored, use them for prettier indentation. Example:
```
megaproject
   v2.0
   file://hello_world.c;
```

double semicolon or semicolon + linebreak or double linebreak or even linebreak + semicolon
can be used for separating packages

first three rules are not exactly "rules" they are corresponding to **_package name_**, **_package version_**
and **_build subdirectory_**.

Rules format
-----------
each next rule is in "command:argument" format
for example
```
extract:http://someserver.com/pacakge-2.1.tar.gz
```

by the way, extract is the default command, so you can type just
```
http://someserver.com/pacakge-2.1.tar.gz
```
if you want only to copy a file to the build directory use
```
nothing:http://someserver/logo.png
```
other available commands are

 1. `dirextract` - first cd to build directory, than extract
 2. `patch` - apply as patch
 3. `rpmbuild` - building from rpm package

install commands
----------------
1. `install -.*` - install file and pass (.*) arguments to install
2. `install_file` - install with -m644
3. `install_bin` - install with -m755

destination file is the last argument
for example
```
install_bin:ftp://megaupload.com/superscript.sh:/bin/script.sh
```

these are most common tasks, see smart-rules.pl for details and feel free to add more..
However, some special rules is better to write directly to .mk file

Special variables
-----------------
To make rules quite you can use two special words, `{PN}` and `{PV}` which refers to package name and version.

__Note:__ in `{PN}` all "_" symbols replaced with "-"

Fetch mechanisms
----------------
Now consider sources that are supported:

1. `http://` - http wget download
2. `ftp://` - ftp wget download
3. `file://` - look for file in Patches directory
4. `git://www.gitserver.com/gitrepo:r=revision:b=branch:sub=subdir_in_git_tree:protocol=http`
    - __revision__, __branch__ and __subdirectory__ to use (arguments are optional).
    -  and __protocol__ which git should use. (replaces 'git://' while fetch)
    - use protocol=ssh to replace "git://" with "git@"
5. `svn://www.svnserver.com/svnrepo:r=revision`
    - only __revision__ option

if rule command doesn't match ones listed above, this is treated as install/uninstall rule.

Real example
------------
below you can see mew lirc rule, which replaces corresponding entries in rules-make, rules-install and rules-archive
It is much less complicated !
```
lirc
  0.9.0
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/lirc/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}-try_first_last_remote.diff
  make:install:DESTDIR=TARGETS
  rewrite-libtool:TARGETS/usr/lib/liblirc_client.la
;
```

How does it interacts with make ?
--------------------------------
Using smart-rules is optional, but smart-rules.pl generates macroses to make downloading, patching etc. tasks a bit easier.
You can find the output of smart-rules.pl script in cdk/ruledir directory.
These files are imported to Makefile after running ./configure (runs automaticaly).

So for example for udpxy you'll have:

-  $(DIR_ntpclient) directory where sources are extracted (buid dir)
-  $(DEPENDS_ntpclient) is list of all files to built package from.
    Place into target depends, so changing one of them invokes rebuild.
-  $(PREPARE_ntpclient) rules for download, extract and patch files above.
-  $(SOURCES_udpxy) list of files above. Used later in package Control file.
-  $(VERSION_udpxy) Used later in package Control file too.
-  $(AUTOPKGV_udpxy) If there is svn or git repo in rules, this command will be generated and you can run it
    to eval $(PKGV_udpxy) based on git date or svn revision.
-  $(INSTALL_udpxy) command could be 'make install' and commands to copy other files to PKDIR.

Make *mk files
==============
You can use it as example of building and making package for new utility.

First of all take a look at smart-rules. Read the documentation at the beginning and write udpxy rules:
```
BEGIN[[
udpxy
  1.0.23-0
  {PN}-{PV}
  http://sourceforge.net/projects/udpxy/files/udpxy/Chipmunk-1.0/udpxy.{PV}-prod.tar.gz
  #for patch -p0 use the following
  patch-0:file://udpxy-makefile.patch
;
]]END
```

Learning by example
-------------------
At the first stage let's build one single package. For example udpxy. Be careful, each package name should be unique.
First of all you should define some necessary info about your package.
Such as 'Description:' field in control file

`DESCRIPTION_udpxy := udp to http stream proxy`

Next set package release number and increase it each time you change something here in make scripts or your own patches.
Release number is part of the package version, updating it tells others that they can upgrade their system now.

`PKGR_udpxy = r0`

Other variables are optional and have default values and another are taken from smart-rules (full list below)

make targets
-----------
Usually each utility is split into three make-targets. Target name and package name 'udpxy' should be the same.

Write  
` $(DEPDIR)/udpxy.do_prepare:`

But not  
` $(DEPDIR)/udpxy_proxy.do_prepare:`

**exceptions** of this rule discussed later.

Also target should contain only A-z characters and underscore "_".

do prepare
----------
Firstly, downloading and patching. Use `$(DEPENDS_udpxy)` from smart rules as target-depends.  
In the body use `$(PREPARE_udpxy)` generated by smart-rules  
You can add your special commands too.
```
$(DEPDIR)/udpxy.do_prepare: $(DEPENDS_udpxy)
        $(PREPARE_udpxy)
        touch $@
```

do compile
----------
Secondly, the configure and compilation stage  
Each target should ends with `touch $@`
```
$(DEPDIR)/udpxy.do_compile: $(DEPDIR)/udpxy.do_prepare
        cd $(DIR_udpxy) && \
                export CC=sh4-linux-gcc && \
                $(MAKE)
        touch $@
```

complete
--------
Finally, install and packaging!

How does it works:

-  start with line `$(start_build)` to prepare temporary directories and determine package name by the target name.
-  At first all files should go to temporary directory `$(PKDIR)` which is cdk/packagingtmpdir.
-  If you fill `$(PKDIR)` correctly then our scripts could proceed.

You could call one of the following:

-   `$(tocdk_build)` - copy all $(PKDIR) contents to tufsbox/cdkroot to use them later if something depends on them.
-   `$(extra_build)` - perform strip and cleanup, then make package ready to install on your box. You can find ipk in tufsbox/ipkbox
-   `$(toflash_build)` - At first do exactly that $(extra_build) does. After install package to pkgroot to include it in image.
-   `$(e2extra_build)` - same as $(extra_build) but copies ipk to tufsbox/ipkextras

__Tip:__ `$(tocdk_build)` and `$(toflash_build)` could be used simultaneously.
```
$(DEPDIR)/udpxy: $(DEPDIR)/udpxy.do_compile
        $(start_build)
        cd $(DIR_udpxy)  && \
                export INSTALLROOT=$(PKDIR)/usr && \
                $(MAKE) install
        $(extra_build)
        touch $@
```

Note: all above defined variables has suffix 'udpxy' same as make-target name '$(DEPDIR)/udpxy'  
If you want to change name of make-target for some reason add $(call parent_pk,udpxy) before $(start_build) line.
Of course place your variables suffix instead of udpxy.

Some words about git and svn.
-----------------------------
It is available to automatically determine version from git and svn

If there is git/svn rule in smart-rules and the version equals git/svn then the version will be automatically evaluated during `$(start_build)`

__Note:__ it is assumed that there is only one repo for the utility.

If you use your own git/svn fetch mechanism we provide you with `$(get_git_version)` or `$(get_svn_version)`, but make sure that `$(DIR_foo)` is git/svn repo.

FILES variable
--------------
FILES variable is the filter for your `$(PKDIR)`, by default it equals "/" so all files from `$(PKDIR)` are built into the package. It is list of files and directories separated by space. Wildcards are supported.
Wildcards used in the FILES variables are processed via the python function fnmatch. The following items are of note about this function:

-  `/<dir>/*`: This will match all files and directories in the dir - it will not match other directories.
-  `/<dir>/a*`: This will only match files, and not directories.
-  `/dir`: will include the directory dir in the package, which in turn will include all files in the directory and all subdirectories.

Info about some additional variables
------------------------------------
-  PKGV_foo
 Taken from smart rules version. Set if you don't use smart-rules
-  SRC_URI_foo
 Sources from which package is built, taken from smart-rules file://, http://, git://, svn:// rules.
-  NAME_foo
 If real package name is too long put it in this variable. By default it is like in varible names.

### CONTROL file ###

Next variables has default values and influence CONTROL file fields only:

-  MAINTAINER_foo := Ar-P team
-  PACKAGE_ARCH_foo := sh4
-  SECTION_foo := base
-  PRIORITY_foo := optional
-  LICENSE_foo := unknown
-  HOMEPAGE_foo := unknown

You set package dependencies in CONTROL file with:

-  RDEPENDS_foo :=
-  RREPLACES :=
-  RCONFLICTS :=

post/pre inst/rm Scripts
------------------------
For these sripts use make define as following:
```
define postinst_foo
!/bin/sh
initdconfig --add foo
endef
```

This is all about scripts
Note: init.d script starting and stopping is handled by initdconfig

Multi-Packaging
---------------
When you whant to split files from one target to different packages you should set PACKAGES_parentfoo value.
By default parentfoo is equals make target name. Place subpackages names to PACKAGES_parentfoo variable,
parentfoo could be also in the list. Example:  
`PACKAGES_megaprog = megaprog_extra megaprog`

Then set FILES for each subpackage  
`FILES_megaprog = /bin/prog /lib/*.so*`  
`FILES_megaprog_extra = /lib/megaprog-addon.so`

__NOTE:__ files are moving to pacakges in same order(priority) they are listed in PACKAGES variable.

Optional install to flash
-------------------------
When you call `$(tocdk_build)`/`$(toflash_build)` all packages are installed to image.
If you want to select some non-installing packages from the same target (multi-packaging case)  
just list them in `EXTRA_parentfoo` variable  
`DIST_parentfoo` variable works vice-versa
