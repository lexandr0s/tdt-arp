# print '+' before each executed command
# SHELL := $(SHELL) -x

MAKE_DEBUG :=

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

# root dir hack
buildprefix := $(shell pwd)
tdtdir := $(patsubst %/cvs/cdk,%,$(buildprefix))

# dependency control dir
DEPDIR := $(buildprefix)/.deps
$(shell mkdir -p $(DEPDIR))
VPATH := $(DEPDIR)

# build root directories
prefix := $(tdtdir)/tufsbox
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

ifdef CONFIG_KERNEL_0207
KERNEL_VERSION := 2.6.32.28_stm24_0207
endif

ifdef CONFIG_KERNEL_0209
KERNEL_VERSION := 2.6.32.46_stm24_0209
endif

ifdef CONFIG_KERNEL_0210
KERNEL_VERSION := 2.6.32.57_stm24_0210
endif

ifdef CONFIG_KERNEL_0211
KERNEL_VERSION := 2.6.32.59_stm24_0211
endif

ifdef CONFIG_KERNEL_0212
KERNEL_VERSION := 2.6.32.61_stm24_0212
endif

KERNEL_VERSION_SPLITED := $(subst _, ,$(KERNEL_VERSION))
KERNEL_UPSTREAM := $(word 1,$(KERNEL_VERSION_SPLITED))
KERNEL_STM := $(word 2,$(KERNEL_VERSION_SPLITED))
KERNEL_LABEL := $(word 3,$(KERNEL_VERSION_SPLITED))
KERNEL_RELEASE := $(subst ^0,,^$(KERNEL_LABEL))
# TODO: add KERNEL_DIR 

STLINUX := stlinux24
#? TODO: STM_RELOCATE := /opt/STM/STLinux-2.4

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
#rpm_build := rpmbuild $(rpm_macros) -bb -v --clean --target=$(target)
rpm_build := rpmbuild $(rpm_macros) -bi -v --nodeps --target=$(target)
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
