#
# EXTRA FONTS
#

DESCRIPTION_fonts_extra = Extra fonts to beautify your box
SRC_URI_fonts_extra = git://gitorious.org/~schpuntik/open-duckbox-project-sh4/tdt-amiko.git
PKGV_fonts_extra = 0.1
SRC_URI_font_valis_enigma = $(SRC_URI_fonts_extra)
PKGV_font_valis_enigma = $(PKGV_fonts_extra)

fonts_extra_file_list = $(subst .ttf,,$(shell ls root/usr/share/fonts/))

# This can be used as multipackaging example
# Remember to replace '-' with '_' in variables and package names

PACKAGES_fonts_extra = $(subst -,_,$(addprefix font_,$(fonts_extra_file_list)))
$(foreach f,$(fonts_extra_file_list), \
 $(eval DESCRIPTION_font_$(subst -,_,$f) = font $f ) \
 $(eval FILES_font_$(subst -,_,$f) = /usr/share/fonts/$f*) \
)

$(DEPDIR)/font-valis-enigma: fonts-extra
	$(start_build)
	$(INSTALL) -d $(PKDIR)/usr/share/fonts
	$(INSTALL) -m 644 root/usr/share/fonts/valis_enigma.ttf $(PKDIR)/usr/share/fonts
	$(toflash_build)
	touch $@

$(DEPDIR)/fonts-extra: $(addsuffix .ttf, $(addprefix root/usr/share/fonts/,$(fonts_extra_file_list)))
	$(start_build)
	$(INSTALL) -d $(PKDIR)/usr/share/fonts
	$(INSTALL) -m 644 $^ $(PKDIR)/usr/share/fonts
	$(extra_build)
	touch $@


#
# parted
#
BEGIN[[
parted
  3.1
  {PN}-{PV}
  extract:http://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.xz
  patch:file://{PN}_{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_parted = "parted"
FILES_parted = \
/usr/lib/libparted-fs-resize.s* \
/usr/lib/libparted.s* \
/usr/sbin/parted

$(DEPDIR)/parted.do_prepare: bootstrap $(DEPENDS_parted)
	$(PREPARE_parted)
	touch $@

$(DEPDIR)/parted.do_compile: $(DEPDIR)/parted.do_prepare
	cd $(DIR_parted) && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-Werror \
			--disable-device-mapper && \
		$(MAKE) all CC=$(target)-gcc STRIP=$(target)-strip
	touch $@

$(DEPDIR)/parted: $(DEPDIR)/parted.do_compile
	$(start_build)
	cd $(DIR_parted) && \
		$(INSTALL_parted)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# gettext
#
BEGIN[[
gettext
  0.18
  {PN}-{PV}
  extract:ftp://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gettext = "gettext"
FILES_gettext = \
*

$(DEPDIR)/gettext.do_prepare: bootstrap $(DEPENDS_gettext)
	$(PREPARE_gettext)
	touch $@

$(DEPDIR)/gettext.do_compile: $(DEPDIR)/gettext.do_prepare
	cd $(DIR_gettext) && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-emacs \
			--without-cvs \
			--disable-java && \
		$(MAKE) all 
	touch $@

$(DEPDIR)/gettext: $(DEPDIR)/gettext.do_compile
	$(start_build)
	cd $(DIR_gettext) && \
		$(INSTALL_gettext)
	$(tocdk_build)
	$(toflash_build)
	touch $@



#
# XFSPROGS
#
BEGIN[[
xfsprogs
  2.9.4-1
  {PN}-2.9.4
  extract:http://pkgs.fedoraproject.org/repo/pkgs/xfsprogs/xfsprogs_2.9.4-1.tar.gz/174683e3b86b587ed59823fdbbb96ea4/{PN}_{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_xfsprogs = "xfsprogs"

FILES_xfsprogs = \
/bin/*

$(DEPDIR)/xfsprogs.do_prepare: bootstrap $(DEPDIR)/e2fsprogs $(DEPDIR)/libreadline $(DEPENDS_xfsprogs)
	$(PREPARE_xfsprogs)
	touch $@

$(DEPDIR)/xfsprogs.do_compile: $(DEPDIR)/xfsprogs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_xfsprogs) && \
		export DEBUG=-DNDEBUG && export OPTIMIZER=-O2 && \
		mv -f aclocal.m4 aclocal.m4.orig && mv Makefile Makefile.sgi || true && chmod 644 Makefile.sgi && \
		aclocal -I m4 -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix= \
			--enable-shared=yes \
			--enable-gettext=yes \
			--enable-readline=yes \
			--enable-editline=no \
			--enable-termcap=yes && \
		cp -p Makefile.sgi Makefile && export top_builddir=`pwd` && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/xfsprogs: $(DEPDIR)/xfsprogs.do_compile
	$(start_build)
	cd $(DIR_xfsprogs) && \
		export top_builddir=`pwd` && \
		$(INSTALL_xfsprogs)
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# MC
#
BEGIN[[
mc
  4.8.1.6
  {PN}-{PV}
  extract:http://www.midnight-commander.org/downloads/{PN}-{PV}.tar.bz2
#nothing:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_mc = "Midnight Commander"

FILES_mc = \
/usr/bin/* \
/usr/etc/mc/* \
/usr/libexec/mc/extfs.d/* \
/usr/libexec/mc/fish/*

$(DEPDIR)/mc.do_prepare: bootstrap glib2 $(DEPENDS_mc)
	$(PREPARE_mc)
	touch $@

$(DEPDIR)/mc.do_compile: $(DEPDIR)/mc.do_prepare | $(NCURSES_DEV)
	cd $(DIR_mc) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-gpm-mouse \
			--with-screen=ncurses \
			--without-x && \
		$(MAKE) all
	touch $@

$(DEPDIR)/mc: glib2 $(DEPDIR)/mc.do_compile
	$(start_build)
	cd $(DIR_mc) && \
		$(INSTALL_mc)
	$(tocdk_build)
	$(toflash_build)
#		export top_builddir=`pwd` && \
#		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
	touch $@


#
# SG3_UTILS
#
BEGIN[[
sg3_utils
  1.24
  sg3_utils-{PV}
  extract:http://sg.torque.net/sg/p/sg3_utils-{PV}.tgz
  patch:file://sg3_utils.diff
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/sg3_utils.do_prepare: bootstrap $(DEPENDS_sg3_utils)
	$(PREPARE_sg3_utils)
	touch $@

$(DEPDIR)/sg3_utils.do_compile: $(DEPDIR)/sg3_utils.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_sg3_utils) && \
		$(MAKE) clean || true && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		automake --add-missing --foreign && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/sg3_utils: $(DEPDIR)/sg3_utils.do_compile
	cd $(DIR_sg3_utils) && \
		export PATH=$(MAKE_PATH) && \
		$(INSTALL_sg3_utils)
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/sbin && \
	touch $@

#
# ZD1211
#
BEGIN[[
zd1211
  2_15_0_0
  ZD1211LnxDrv_2_15_0_0
  extract:http://www.lutec.eu/treiber/{PN}lnxdrv_2_15_0_0.tar.gz
  patch:file://{PN}.diff
;
]]END

CONFIG_ZD1211B :=
$(DEPDIR)/zd1211.do_prepare: bootstrap $(DEPENDS_zd1211)
	$(PREPARE_zd1211)
	touch $@

$(DEPDIR)/zd1211.do_compile: $(DEPDIR)/zd1211.do_prepare
	cd $(DIR_zd1211) && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			ZD1211B=$(ZD1211B) \
			CROSS_COMPILE=$(target)- ARCH=sh
	touch $@

$(DEPDIR)/zd1211: $(DEPDIR)/zd1211.do_compile
	cd $(DIR_zd1211) && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			BIN_DEST=$(targetprefix)/bin \
			INSTALL_MOD_PATH=$(targetprefix) \
			install
	$(DEPMOD) -ae -b $(targetprefix) -r $(KERNELVERSION)
	touch $@

#
# NANO
#
BEGIN[[
nano
  2.0.6
  {PN}-{PV}
  extract:http://www.{PN}-editor.org/dist/v2.0/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/nano.do_prepare: bootstrap ncurses ncurses-dev $(DEPENDS_nano)
	$(PREPARE_nano)
	touch $@

$(DEPDIR)/nano.do_compile: $(DEPDIR)/nano.do_prepare
	cd $(DIR_nano) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			--enable-tiny \
			--enable-color && \
		$(MAKE)
	touch $@

$(DEPDIR)/nano: $(DEPDIR)/nano.do_compile
	cd $(DIR_nano) && \
		$(INSTALL_nano)
	touch $@

#
# libdreamdvd
#
BEGIN[[
libdreamdvd
  git
  {PN}
  plink:../apps/misc/tools/{PN}:{PN}
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END


DESCRIPTION_libdreamdvd = libdvdnav wrapper for enigma2 based stbs.
PKGR_libdreamdvd = r1
FILES_libdreamdvd = \
/usr/lib/libdreamdvd*

SRC_URI_libdreamdvd = "libdreamdvd"

$(DEPDIR)/libdreamdvd.do_prepare: bootstrap $(DEPENDS_libdreamdvd)
	$(PREPARE_libdreamdvd)
	touch $@

$(DEPDIR)/libdreamdvd.do_compile: $(DEPDIR)/libdreamdvd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdreamdvd) && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdreamdvd: $(DEPDIR)/libdreamdvd.do_compile
	$(start_build)
	cd $(DIR_libdreamdvd) && \
		$(INSTALL_libdreamdvd)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libmodplug
#
BEGIN[[
libmodplug
  0.8.8.4
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/project/modplug-xmms/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmodplug = "the library for decoding mod-like music formats"

FILES_libmodplug = \
/usr/lib/lib*

$(DEPDIR)/libmodplug.do_prepare: bootstrap $(DEPENDS_libmodplug)
	$(PREPARE_libmodplug)
	touch $@

$(DEPDIR)/libmodplug.do_compile: $(DEPDIR)/libmodplug.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmodplug) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmodplug: $(DEPDIR)/libmodplug.do_compile
	$(start_build)
	cd $(DIR_libmodplug) && \
		$(INSTALL_libmodplug)
	$(tocdk_build)
	$(toflash_build)
	touch $@
