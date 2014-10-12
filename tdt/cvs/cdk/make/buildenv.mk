# print '+' before each executed command
# SHELL := $(SHELL) -x

MAKE_DEBUG :=

# Don't pass any toplevel flags to child make
# such as make execution in do_compile
# It is individual recipe
unexport MAKEFLAGS

# disable built in rules variables
# print why target is rebuilt
ifeq ($(MAKE_VERSION),4.0)
MAKEFLAGS := -r -R --trace
endif


# gnu make strings magic
empty :=
define newline


endef
space := $(empty) $(empty)
comma := ,

# eval_define
# - 1: variable name
# - 2: variable value
eval_define = $(eval define $1 $(newline)$(value $2)$(newline)endef) \
       $(if $(MAKE_DEBUG), \
              $(info define $1 $(newline)$(value $2)$(newline)endef) \
       )
# eval_assign
# - 1: variable name
# - 2: variable value
eval_assign = $(eval $1 = $(value $2)) \
       $(if $(MAKE_DEBUG), \
              $(info $1 = $(value $2)) \
       )

# trivial consts
false :=
true := y

# check if variable is defined
# - 1: variable name
defined = $(if $(findstring undefined,$(origin $1)),$(false),$(true))

# check if variable is undefined
# - 1: variable name
undefined = $(if $(findstring undefined,$(origin $1)),$(true),$(false))

# For parallel builds, some targets may share same resources
# Put it in a recipie and it will be only one instance of foo_command at the same time
# usage $(call lock_run,foo.lock) foo_command
# we use it for opkg for example
lock = lock_run() { (flock --timeout 60 --exclusive 200 && $$@) 200>$1; } && lock_run


# global consts
target_arch := sh4
target := sh4-linux

# detect host system 32 or 64 bit
host_arch := $(shell which arch > /dev/null 2>&1 && arch || uname -m)
ifeq ($(host_arch),i686)
host := $(host_arch)-pc-linux-gnu
else
host := $(host_arch)-unknown-linux-gnu
endif
build := $(host)

# selected target box
ifdef CONFIG_SPARK
TARGET := spark
endif
ifdef CONFIG_SPARK7162
TARGET := spark7162
endif
ifdef CONFIG_HL101
TARGET := hl101
endif
box_arch := $(TARGET)

# directories
archivedir = $(HOME)/Archive

# FIXME: root dir hack
buildprefix := $(shell pwd)
tdtdir := $(patsubst %/cvs/cdk,%,$(buildprefix))

# build root directories
prefix := $(tdtdir)/tufsbox

# dependency control dir
DEPDIR := $(prefix)/.deps
$(shell mkdir -p $(DEPDIR))
VPATH := $(DEPDIR)

$(if $(shell test -d $(DEPDIR) || echo fail), $(error unable to create directory $(DEPDIR)) )

# host
hostprefix := $(prefix)/host
ipkhost := $(prefix)/ipkhost
# cross
devkitprefix := $(prefix)/devkit
crossprefix := $(devkitprefix)/sh4
targetsh4prefix := $(prefix)/target-sh4
ipkcross := $(prefix)/ipkcross
# target
targetprefix := $(prefix)/target
targetboxprefix := $(prefix)/target-$(TARGET)
ipktarget := $(prefix)/ipktarget
# kernel sources dir
kernelprefix := $(devkitprefix)/sources/kernel

ipkbox := $(prefix)/ipkbox
ipkorigin := $(prefix)/ipkbox-origin

# strange directories
configprefix := $(hostprefix)/config
appsdir := $(tdtdir)/cvs/apps
driverdir := $(tdtdir)/cvs/driver

# build temporary directories
specsprefix := $(prefix)/SPECS
sourcesprefix := $(prefix)/SOURCES
workprefix := $(prefix)/work

# FIXME:
export CFLAGS = -g -O2
export CXXFLAGS = -g -O2

# Kernel configuration


ifdef CONFIG_KERNEL_0211
KERNEL_VERSION := 2.6.32.59_stm24_0211
endif

ifdef CONFIG_KERNEL_0215
KERNEL_VERSION := 2.6.32.61_stm24_0215
endif

KERNEL_VERSION_SPLITED := $(subst _, ,$(KERNEL_VERSION))
KERNEL_UPSTREAM := $(word 1,$(KERNEL_VERSION_SPLITED))
KERNEL_STM := $(word 2,$(KERNEL_VERSION_SPLITED))
KERNEL_LABEL := $(word 3,$(KERNEL_VERSION_SPLITED))
KERNEL_RELEASE := $(subst ^0,,^$(KERNEL_LABEL))
# TODO: add KERNEL_DIR 

STLINUX := stlinux24
#? TODO: STM_RELOCATE := /opt/STM/STLinux-2.4

# save system default PATH
HOST_PATH := $(PATH)
# PATH is exported automatically
PATH := $(crossprefix)/bin:$(hostprefix)/bin:$(PATH)
ifdef ENABLE_CCACHE
PATH := $(hostprefix)/ccache-bin:$(PATH)
endif


# TODO: review these variables
DEPMOD = $(hostprefix)/bin/depmod
SOCKSIFY=
WGET=$(SOCKSIFY) wget -P

INSTALL := install
INSTALL_DIR=$(INSTALL) -d
INSTALL_BIN=$(INSTALL) -m 755
INSTALL_FILE=$(INSTALL) -m 644
LN_SF=$(shell which ln) -sf
CP_D=$(shell which cp) -d
CP_P=$(shell which cp) -p
CP_RD=$(shell which cp) -rd
SED=$(shell which sed)

BUILDENV := \
	source $(buildprefix)/build.env &&

EXPORT_BUILDENV := \
	export PATH=$(PATH) && \
	export CC=$(target)-gcc && \
	export CXX=$(target)-g++ && \
	export LD=$(target)-ld && \
	export NM=$(target)-nm && \
	export AR=$(target)-ar && \
	export AS=$(target)-as && \
	export RANLIB=$(target)-ranlib && \
	export STRIP=$(target)-strip && \
	export OBJCOPY=$(target)-objcopy && \
	export OBJDUMP=$(target)-objdump && \
	export LN_S="ln -s" && \
	export CFLAGS="$(TARGET_CFLAGS)" && \
	export CXXFLAGS="$(TARGET_CFLAGS)" && \
	export LDFLAGS="$(TARGET_LDFLAGS) -Wl,-rpath-link,$(PKDIR)/usr/lib" && \
	export PKG_CONFIG_SYSROOT_DIR="$(targetprefix)" && \
	export PKG_CONFIG_PATH="$(targetprefix)/usr/lib/pkgconfig" && \
	export PKG_CONFIG_LIBDIR="$(targetprefix)/usr/lib/pkgconfig"

build.env:
	echo '$(EXPORT_BUILDENV)' |sed 's/&&/\n/g' |sed 's/^ //' > $@

MAKE_ARGS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s"

PLATFORM_CPPFLAGS := $(CPPFLAGS) -I$(driverdir)/include -I$(appsdir)/misc/tools
ifdef CONFIG_SPARK
PLATFORM_CPPFLAGS += -DPLATFORM_SPARK
endif
ifdef CONFIG_SPARK7162
PLATFORM_CPPFLAGS += -DPLATFORM_SPARK7162
endif
ifdef CONFIG_HL101
PLATFORM_CPPFLAGS += -DPLATFORM_HL101
endif
PLATFORM_CPPFLAGS := CPPFLAGS="$(PLATFORM_CPPFLAGS)"

# FIXME
start_build = $(error obsolete)

# TODO: move it somewhere
# all helpers
PKDIR_clean = rm -rf $(PKDIR)/* && mkdir -p $(PKDIR)

# rpm helpers
rpm_macros := --macros /usr/lib/rpm/macros:$(configprefix)/rpm/hosts/$(build):$(configprefix)/rpm/targets/$(target):$(configprefix)/rpm/common:$(buildprefix)/localmacros
# --dbpath $(prefix)/rpmdb
rpm_src_install := rpm $(rpm_macros) --ignorearch --nosignature -Uhv
# be careful PKDIR is dynamic variable related to current make target name
rpm_compile = rpmbuild $(rpm_macros) -bc -v --nodeps --target=$(target)
rpm_build = rpmbuild $(rpm_macros) -bi -v --nodeps --target=$(target) --buildroot=$(PKDIR) -D '%_builddir $(WORK_${P})'
rpm_install := rpm $(rpm_macros)  --ignorearch --nodeps -Uhv

# python helpers
python_build = \
	CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
	CPPFLAGS="-I$(targetprefix)/usr/include/python$(PYTHON_VERSION)" \
	PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
	$(crossprefix)/bin/python ./setup.py build

#	$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build

python_install = \
	CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
	PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
	$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
