tdt-arp
=======================

Image build-system for settopboxes sh4 based
remake of duckbox tdt

Start
=======================
Preparation

 0. To avoid data loss I _recommend_ you to run this build system under individual user. So these build scripts have no chance to mess in your main home directory !
 1. Your host system requires some packages. Run `sudo ./setuptdt.sh`. If don't like to run unknown scripts under root install them manually

That's it, now start toolchain
 2. Generate config: run `make -f Makefile.setup xconfig` or `make -f Makefile.setup menuconfig`
 3. Generate core Makefile run `make -f Makefile.setup`
 4. Add make compleshion by <TAB>: `source make-compleshion.sh`
 5. To build image exec buildsystem with `make target-image`
 6. A lot of make targets are available


Smart-rules
=======================
Smart-rules is Makefile preprocessor written in perl, it helps to write simpler Makefiles.

`Makefile.pre --> |smart-rules.pl| --> Makefile`

You must understand that **firstly** it expands all **smart-rules** macroses, and **secondly** make evaluates **Makefile variables**.

rules section
-----------------------
##### example
```
rule[[
   extract:http://project.com/prog-${PKGV}.tar.gz
   file://hello_world.c;
   patch:file://fixqq.diff
]]rule
```
##### format
Rules are separated by line break, all trailing white-spaces are ignored, use them for prettier indentation. Use `#` for comments, Makefile conditionals are not touched.
```
rule[[
  <rule1>  # this is comment
ifdef FEATURE_2
  <rule2>
endif
  ...
  ...
  ...
]]rule
```
##### purpose
This macro defines variables for future use in Makefile. They are `DEPENDS` , `PREPARE` , `INSTALL` and `SRC_URI`. Additional special targets and variables also printed to Makefile.

rule format
----------------------
variants are
```
command:arg1:arg2:...:url:url-arg1:url-arg2:....
url:url-arg1:url-arg2:.... # default is extract command with no arguments
command:arg1:arg2:...      # some commands doesn't require url.
```
url is detected by `protocol://path` pattern.
If `;` is found in rule it becomes a separator instead of `:`.

stage prepare
-------------
Commands that result in `PREPARE` variable

*__nothing|extract|dirextract|patch(-(\\d+))?|pmove|premove|plink|pdircreate__*
* __nothing__ <br>
  copy file to ${DIR}. No arguments, url required
* __extract__ <br>
  extract archive to $(workprefix). No arguments, url required
* __dirextract__ <br>
  extract archive to ${DIR}. No arguments, url required
* __patch__ or __patch-%d__ <br>
   execute `patch -p%d arg1 arg2 ...` url required, default patch level is 1
* __pmove__ <br>
  execute `mv arg1 arg2` url not supported
* __premove__ <br>
   execute `rm -rf arg1` url not supported
* __plink__ <br>
  execute `ln -sf arg1 arg2`. url not supported
* __pdircreate__ <br>
  execute `mkdir -p arg1` url is not supported

stage install
------------
Commands that result in `INSTALL` variable

*__install|install_file|install_bin|make|move|remove|mkdir|link__*
* __install__ <br>
  execute `install arg1 arg2 ...` If url is not provided <br>
  or <br>
  execute `install file arg1 arg2 ...` Where file is downloaded from url
* __install_file__ <br>
  execute `install file -m644 arg1 arg2 ...` Where file is downloaded from url
* __install_bin__ <br>
  execute `install file -m755 arg1 arg2 ...` Where file is downloaded from url
* __make__ <br>
  execute `make arg1 arg2 ...` url is not supported
* __move__ <br>
  execute `mv arg1 arg2` url not supported
* __remove__ <br>
  execute `rm -rf arg1` url not supported
* __mkdir__ <br>
  execute `mkdir -p arg1` url is not supported
* __link__ <br>
  execute `ln -sf arg1 arg2` url not supported

these are most common tasks, see smart-rules.pl for details and feel free to add more..
However, some special rules is better to write directly to .mk file

Fetch mechanisms
----------------
Now consider sources that are supported. Each url creates rule for downloading file, and append it to `DEPENDS` variable. Also url is appended to `SRC_URI` variable for future use in opkg CONTROL file.

*__https|http|ftp|file|git|svn|local|localwork__*

* `http://` - http wget download
* `https://` - https wget download
* `ftp://` - ftp wget download
* `git://www.gitserver.com/gitrepo:r=revision:b=branch:sub=subdir_in_git_tree:protocol=http`
   - __revision__, __branch__ and __subdirectory__ to use (arguments are optional).
   -  and __protocol__ which git should use. (replaces 'git://' while fetch)
   - use protocol=ssh to replace "git://" with "git@"
* `svn://www.svnserver.com/svnrepo:r=revision`
   - only __revision__ option
* `file://` - file path prefixed with $(srcdir)/make/
* `localwork://` - temporary file in ${DIR}
* `local://` - not prefixed file name.
