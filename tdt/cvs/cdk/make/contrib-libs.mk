#
# libboost
#
BEGIN[[
libboost
  boost-1.53.0
  boost_1_53_0
  extract:http://prdownloads.sourceforge.net/sourceforge/boost/boost_1_53_0.tar.bz2
  patch:file://{PN}.diff
  remove:TARGETS/include/boost
  move:boost:TARGETS/usr/include/boost
;
]]END

$(DEPDIR)/libboost: bootstrap $(DEPENDS_libboost)
	$(PREPARE_libboost)
	cd $(DIR_libboost) && \
		$(INSTALL_libboost)
	touch $@

#
# libiconv
#
BEGIN[[
libiconv
  1.14
  {PN}-{PV}
  extract:http://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libiconv = "libiconv"

FILES_libiconv = \
/usr/lib/*.so* \
/usr/bin/iconv

$(DEPDIR)/libiconv.do_prepare: bootstrap $(DEPENDS_libiconv)
	$(PREPARE_libiconv)
	touch $@

$(DEPDIR)/libiconv.do_compile: $(DEPDIR)/libiconv.do_prepare
	cd $(DIR_libiconv) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libiconv: $(DEPDIR)/libiconv.do_compile
	$(start_build)
	cd $(DIR_libiconv) && \
		cp ./srcm4/* $(hostprefix)/share/aclocal/ && \
		$(INSTALL_libiconv)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libmng
#
BEGIN[[
libmng
  1.0.10
  {PN}-{PV}
  extract:http://dfn.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmng = "libmng - Multiple-image Network Graphics"

FILES_libmng = \
/usr/lib/*.so*

$(DEPDIR)/libmng.do_prepare: bootstrap libz libjpeg lcms $(DEPENDS_libmng)
	$(PREPARE_libmng)
	touch $@

$(DEPDIR)/libmng.do_compile: $(DEPDIR)/libmng.do_prepare
	cd $(DIR_libmng) && \
		cat unmaintained/autogen.sh | tr -d \\r > autogen.sh && chmod 755 autogen.sh && \
		[ ! -x ./configure ] && ./autogen.sh --help || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static \
			--with-zlib \
			--with-jpeg \
			--with-gnu-ld \
			--with-lcms && \
		$(MAKE)
	touch $@

$(DEPDIR)/libmng: $(DEPDIR)/libmng.do_compile
	$(start_build)
	cd $(DIR_libmng) && \
		$(INSTALL_libmng)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# lcms
#
BEGIN[[
lcms
  1.17
  {PN}-{PV}
  extract:http://dfn.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lcms = "lcms"

FILES_lcms = \
/usr/lib/*

$(DEPDIR)/lcms.do_prepare: bootstrap libz libjpeg $(DEPENDS_lcms)
	$(PREPARE_lcms)
	touch $@

$(DEPDIR)/lcms.do_compile: $(DEPDIR)/lcms.do_prepare
	cd $(DIR_lcms) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static && \
		$(MAKE)
	touch $@

$(DEPDIR)/lcms: $(DEPDIR)/lcms.do_compile
	$(start_build)
	cd $(DIR_lcms) && \
		$(INSTALL_lcms)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# directfb
#
BEGIN[[
directfb
  1.6.3
  DirectFB-{PV}
  extract:http://ptxdist.sat-universum.de/DirectFB-{PV}.tar.bz2
  patch:file://{PN}-{PV}.stm.patch
  patch:file://{PN}-{PV}.no-vt.diff
  patch:file://{PN}-{PV}.enigma2remote.diff
  make:install:DESTDIR=PKDIR:LD=sh4-linux-ld
;
]]END

DESCRIPTION_directfb = "directfb"
BDEPENDS_directfb = \
		libpng \
		libjpeg \
		tiff \
		jasper

FILES_directfb = \
/usr/lib/*.so* \
/usr/lib/directfb-1.6-0-pure/gfxdrivers/*.so* \
/usr/lib/directfb-1.6-0-pure/inputdrivers/*.so* \
/usr/lib/directfb-1.6-0-pure/interfaces/*.so* \
/usr/lib/directfb-1.6-0-pure/systems/libdirectfb_stmfbdev.so \
/usr/lib/directfb-1.6-0-pure/wm/*.so* \
/usr/bin/dfbinfo

$(DEPDIR)/directfb.do_prepare: bootstrap freetype fluxcomp_host $(DEPENDS_directfb)
	$(PREPARE_directfb)
	touch $@

$(DEPDIR)/directfb.do_compile: $(DEPDIR)/directfb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_directfb) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="-02" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--with-tests \
			--with-tools \
			--disable-osx \
			--disable-network \
			--disable-multicore \
			--disable-multi \
			--enable-voodoo \
			--disable-devmem \
			--disable-sdl \
			--disable-webp \
			--with-message-size=65536 \
			--disable-linotype \
			--disable-vnc \
			--disable-zlib \
			--with-inputdrivers=keyboard,linuxinput,ps2mouse,enigma2remote \
			--disable-x11 \
			--disable-fbdev \
			--enable-stmfbdev \
			--disable-video4linux \
			--disable-video4linux2 \
			--disable-debug-support \
			--disable-trace \
			--enable-mme \
			--disable-unique \
			--enable-gif \
			--enable-png \
			--enable-jpeg \
			--enable-freetype && \
			export top_builddir=`pwd` && \
		$(MAKE)
	touch $@

$(DEPDIR)/directfb: $(DEPDIR)/directfb.do_compile
	$(start_build)
	cd $(DIR_directfb) && \
		$(INSTALL_directfb)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# fluxcomp_host
#
BEGIN[[
fluxcomp_host
  git
  {PN}-{PV}
  nothing:git://git.directfb.org/git/directfb/core/flux.git
  make:install
;
]]END


$(DEPDIR)/fluxcomp_host: bootstrap $(DEPENDS_fluxcomp_host)
	$(PREPARE_fluxcomp_host)
	cd $(DIR_fluxcomp_host) && \
	./autogen.sh &&\
	./configure \
		--prefix=$(crossprefix) && \
	$(MAKE) all PREFIX=$(crossprefix) && \
	$(MAKE) install PREFIX=$(crossprefix)
	touch $@

#
# DFB++
#
BEGIN[[
dfbpp
  1.0.0
  DFB++-{PV}
  extract:http://www.directfb.org/downloads/Extras/DFB++-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_dfbpp = ""

FILES_dfbpp = \
/usr/lib/*.so*

$(DEPDIR)/dfbpp.do_prepare: bootstrap libz libjpeg directfb $(DEPENDS_dfbpp)
	$(PREPARE_dfbpp)
	touch $@

$(DEPDIR)/dfbpp.do_compile: $(DEPDIR)/dfbpp.do_prepare
	cd $(DIR_dfbpp) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/dfbpp: $(DEPDIR)/dfbpp.do_compile
	$(start_build)
	cd $(DIR_dfbpp) && \
		$(INSTALL_dfbpp)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# LIBSTGLES
#
BEGIN[[
libstgles
  git
  {PN}-{PV}
  plink:$(appsdir)/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libstgles = "libstgles"
SRC_URI_libstgles = "https://code.google.com/p/tdt-amiko/"
PKGR_libstgles =r1
FILES_libstgles = \
/usr/lib/*

$(DEPDIR)/libstgles.do_prepare: bootstrap directfb $(DEPENDS_libstgles)
	$(PREPARE_libstgles)
	touch $@

$(DEPDIR)/libstgles.do_compile: $(DEPDIR)/libstgles.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libstgles) && \
	cp --remove-destination $(hostprefix)/share/libtool/config/ltmain.sh . && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/libstgles: $(DEPDIR)/libstgles.do_compile
	$(start_build)
	cd $(DIR_libstgles) && \
		$(INSTALL_libstgles)
	$(tocdk_build)
	$(toflash_build)
	touch $@

# WebKitDFB
#
BEGIN[[
webkitdfb
  2010-11-18
  {PN}_{PV}
  extract:http://www.duckbox.info/files/packages/{PN}_{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_webkitdfb = "webkitdfb"
BDEPENDS_webkitdfb = glib2 icu4c libxml2 enchant lite curl fontconfig sqlite libsoup cairo libjpeg

FILES_webkitdfb = \
/usr/lib*

$(DEPDIR)/webkitdfb.do_prepare: bootstrap $(DEPENDS_webkitdfb)
	$(PREPARE_webkitdfb)
	touch $@

$(DEPDIR)/webkitdfb.do_compile: $(DEPDIR)/webkitdfb.do_prepare
	export PATH=$(buildprefix)/$(DIR_icu4c)/host/config:$(PATH) && \
	cd $(DIR_webkitdfb) && \
	$(BUILDENV) \
	./autogen.sh \
		--with-target=directfb \
		--without-gtkplus \
		--host=$(target) \
		--prefix=/usr \
		--with-cairo-directfb \
		--disable-shared-workers \
		--enable-optimizations \
		--disable-channel-messaging \
		--disable-javascript-debugger \
		--enable-offline-web-applications \
		--enable-dom-storage \
		--enable-database \
		--disable-eventsource \
		--enable-icon-database \
		--enable-datalist \
		--disable-video \
		--enable-svg \
		--enable-xpath \
		--disable-xslt \
		--disable-dashboard-support \
		--disable-geolocation \
		--disable-workers \
		--disable-web-sockets \
		--with-networking-backend=soup
	touch $@

$(DEPDIR)/webkitdfb: $(DEPDIR)/webkitdfb.do_compile
	$(start_build)
	cd $(DIR_webkitdfb) && \
		$(INSTALL_webkitdfb)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# icu4c
#
BEGIN[[
icu4c
  4_4_1
  icu/source
  extract:http://download.icu-project.org/files/{PN}/4.4.1/{PN}-4_4_1-src.tgz
  nothing:file://{PN}-4_4_1_locales.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_icu4c = "icu4c"

FILES_icu4c = \
/usr/lib/*.so* \
/usr/bin/* \
/usr/sbin/*

$(DEPDIR)/icu4c.do_prepare: bootstrap $(DEPENDS_icu4c)
	$(PREPARE_icu4c)
	cd $(DIR_icu4c) && \
		rm data/mappings/ucm*.mk; \
		patch -p1 < $(buildprefix)/Patches/icu4c-4_4_1_locales.patch;
	touch $@

$(DEPDIR)/icu4c.do_compile: $(DEPDIR)/icu4c.do_prepare
	echo "Building host icu"
	mkdir -p $(DIR_icu4c)/host && \
	cd $(DIR_icu4c)/host && \
	sh ../configure --disable-samples --disable-tests && \
	unset TARGET && \
	make
	echo "Building cross icu"
	cd $(DIR_icu4c) && \
	$(BUILDENV) \
	./configure \
		--with-cross-build=$(buildprefix)/$(DIR_icu4c)/host \
		--host=$(target) \
		--prefix=/usr \
		--disable-extras \
		--disable-layout \
		--disable-tests \
		--disable-samples
	touch $@

$(DEPDIR)/icu4c: $(DEPDIR)/icu4c.do_compile
	$(start_build)
	cd $(DIR_icu4c) && \
		unset TARGET && \
		$(INSTALL_icu4c)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# enchant
#
BEGIN[[
enchant
  1.5.0
  {PN}-{PV}
  extract:http://www.abisource.com/downloads/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_enchant = "libenchant -- Generic spell checking library"

FILES_enchant = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/enchant.do_prepare: bootstrap $(DEPENDS_enchant)
	$(PREPARE_enchant)
	touch $@

$(DEPDIR)/enchant.do_compile: $(DEPDIR)/enchant.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_enchant) && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--disable-aspell \
		--disable-ispell \
		--disable-myspell \
		--disable-zemberek \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/enchant: $(DEPDIR)/enchant.do_compile
	$(start_build)
	cd $(DIR_enchant) && \
		$(INSTALL_enchant)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# lite
#
BEGIN[[
lite
  0.9.0
  {PN}-{PV}+git0.7982ccc
  extract:http://www.duckbox.info/files/packages/{PN}-{PV}+git0.7982ccc.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lite = "LiTE is a Toolkit Engine"

FILES_lite = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/lite.do_prepare: bootstrap directfb $(DEPENDS_lite)
	$(PREPARE_lite)
	touch $@

$(DEPDIR)/lite.do_compile: $(DEPDIR)/lite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_lite) && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-debug
	touch $@

$(DEPDIR)/lite: $(DEPDIR)/lite.do_compile
	$(start_build)
	cd $(DIR_lite) && \
		$(INSTALL_lite)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
#
# libgd2
#
BEGIN[[
libgd2
  2.0.35
  gd-{PV}
  extract:http://www.chipsnbytes.net/downloads/gd-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libgd2 = "A graphics library for fast image creation"

FILES_libgd2 = \
/usr/lib/libgd* \
/usr/bin/*

$(DEPDIR)/libgd2.do_prepare: bootstrap libz libpng libjpeg libiconv freetype fontconfig $(DEPENDS_libgd2)
	$(PREPARE_libgd2)
	touch $@

$(DEPDIR)/libgd2.do_compile: $(DEPDIR)/libgd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libgd2) && \
	chmod +w configure && \
	libtoolize -f -c && \
	autoreconf --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libgd2: $(DEPDIR)/libgd2.do_compile
	$(start_build)
	cd $(DIR_libgd2) && \
		$(INSTALL_libgd2)
	$(tocdk_build)
	$(toflash_build)
	touch $@


##############################   END EXTERNAL_LCD   #############################


#
# eve-browser
#
BEGIN[[
evebrowser
  svn
  {PN}-{PV}
  svn://eve-browser.googlecode.com/svn/trunk/
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_evebrowser = evebrowser for HbbTv
#RDEPENDS_evebrowser = webkitdfb
FILES_evebrowser = \
/usr/lib/*.so* \
/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/bin/hbbtvscan-sh4 \
/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/*.py

$(DEPDIR)/evebrowser.do_prepare: bootstrap $(DEPENDS_evebrowser)
	$(PREPARE_evebrowser)
	touch $@

$(DEPDIR)/evebrowser.do_compile: $(DEPDIR)/evebrowser.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_evebrowser) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
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

$(DEPDIR)/evebrowser: $(DEPDIR)/evebrowser.do_compile
	$(start_build)
	mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/ && \
	cd $(DIR_evebrowser) && \
		$(INSTALL_evebrowser) && \
		cp -ar enigma2/HbbTv $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/ && \
		rm -r $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/bin/hbbtvscan-mipsel && \
		rm -r $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/bin/hbbtvscan-powerpc && \
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# brofs
#
BEGIN[[
brofs
  1.2
  BroFS{PV}
  extract:http://www.avalpa.com/assets/freesoft/other/BroFS{PV}.tgz
  make:install:prefix=/usr/bin:DESTDIR=PKDIR
;
]]END

DESCRIPTION_brofs = "BROFS (BroadcastReadOnlyFileSystem)"
FILES_brofs = \
/usr/bin/*

$(DEPDIR)/brofs.do_prepare: bootstrap $(DEPENDS_brofs)
	$(PREPARE_brofs)
	touch $@

$(DEPDIR)/brofs.do_compile: $(DEPDIR)/brofs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_brofs) && \
	$(BUILDENV) \
	$(MAKE) all
	touch $@

$(DEPDIR)/brofs: $(DEPDIR)/brofs.do_compile
	$(start_build)
	mkdir -p $(PKDIR)/usr/bin/
	cd $(DIR_brofs) && \
		$(INSTALL_brofs)
		mv -b $(PKDIR)/BroFS $(PKDIR)/usr/bin/ && \
		mv -b $(PKDIR)/BroFSCommand $(PKDIR)/usr/bin/ && \
		rm -r $(PKDIR)/BroFSd && \
		cd $(PKDIR)/usr/bin/ && \
		ln -sf BroFS BroFSd && \
	$(tocdk_build)
	$(toflash_build)
	touch $@
#
# libmpeg2
#
BEGIN[[
libmpeg2
  0.5.1
  {PN}-{PV}
  extract:http://{PN}.sourceforge.net/files/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END
PACKAGES_libmpeg2 = libmpeg2 \
		    libmpeg2convert0 \
		    mpeg2dec

DESCRIPTION_libmpeg2 = Library and test program for decoding MPEG-2 and MPEG-1 video streams
RDEPENDS_libmpeg2 = libc6
define postinst_libmpeg2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libmpeg2 = /usr/lib/libmpeg2.*

DESCRIPTION_libmpeg2convert0 =  Library and test program for decoding MPEG-2 and MPEG-1 video streams
RDEPENDS_libmpeg2convert0 = libc6
define postinst_libmpeg2convert0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libmpeg2convert0 = /usr/lib/libmpeg2convert.*

DESCRIPTION_mpeg2dec =  Library and test program for decoding MPEG-2 and MPEG-1 video streams
RDEPENDS_mpeg2dec = libmpeg2 libmpeg2convert0 libc6
FILES_mpeg2dec = /usr/bin/*

$(DEPDIR)/libmpeg2.do_prepare: bootstrap $(DEPENDS_libmpeg2)
	$(PREPARE_libmpeg2)
	touch $@

$(DEPDIR)/libmpeg2.do_compile: $(DEPDIR)/libmpeg2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmpeg2) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-debug \
		--disable-accel-detect \
		--disable-sdl \
		--disable-warnings \
		--disable-gprof \
		--without-x&& \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmpeg2: $(DEPDIR)/libmpeg2.do_compile
	$(start_build)
	cd $(DIR_libmpeg2) && \
		$(INSTALL_libmpeg2)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libsamplerate
#
BEGIN[[
libsamplerate
  0.1.8
  {PN}-{PV}
  extract:http://www.mega-nerd.com/SRC/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_libsamplerate = libsamplerate0
DESCRIPTION_libsamplerate = Audio Sample Rate Conversion library
RDEPENDS_libsamplerate = libsndfile1 libc6
define postinst_libsamplerate
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libsamplerate = /usr/lib/libsamplerate.* /usr/bin/sndfile*

$(DEPDIR)/libsamplerate.do_prepare: bootstrap $(DEPENDS_libsamplerate)
	$(PREPARE_libsamplerate)
	touch $@

$(DEPDIR)/libsamplerate.do_compile: $(DEPDIR)/libsamplerate.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libsamplerate) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libsamplerate: $(DEPDIR)/libsamplerate.do_compile
	$(start_build)
	cd $(DIR_libsamplerate) && \
		$(INSTALL_libsamplerate)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# tiff
#
BEGIN[[
tiff
  4.0.3
  {PN}-{PV}
  extract:ftp://ftp.remotesensing.org/pub/lib{PN}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

PACKAGES_tiff = libtiff5 \
		libtiffxx5 \
		libtiff_utils

DESCRIPTION_libtiff5 =  Provides support for the Tag Image File Format (TIFF).
RDEPENDS_libtiff5 = liblzma5 libz1 libjpeg8 libc6
define postinst_libtiff5
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libtiff5 = /usr/lib/libtiff.*

DESCRIPTION_libtiffxx5 =  Provides support for the Tag Image File Format (TIFF).
RDEPENDS_libtiffxx5 = libgcc1 libstdc++6 liblzma5 libtiff5 libz1 libjpeg8 libc6
define postinst_libtiffxx5
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libtiffxx5 = /usr/lib/libtiffxx.*

DESCRIPTION_libtiff_utils =  Provides support for the Tag Image File Format (TIFF).
RDEPENDS_libtiff_utils = libtiff5 libc6
FILES_libtiff_utils = /usr/bin/*

$(DEPDIR)/tiff.do_prepare: bootstrap $(DEPENDS_tiff)
	$(PREPARE_tiff)
	touch $@

$(DEPDIR)/tiff.do_compile: $(DEPDIR)/tiff.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_tiff) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tiff: $(DEPDIR)/tiff.do_compile
	$(start_build)
	cd $(DIR_tiff) && \
		$(INSTALL_tiff)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# lzo
#
BEGIN[[
lzo
  2.06
  {PN}-{PV}
  extract:http://www.oberhumer.com/opensource/{PN}/download/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_lzo = liblzo2-2
DESCRIPTION_lzo = Lossless data compression library
RDEPENDS_lzo = libc6
define postinst_lzo
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_lzo = /usr/lib/liblzo2.*

$(DEPDIR)/lzo.do_prepare: $(DEPENDS_lzo)
	$(PREPARE_lzo)
	touch $@

$(DEPDIR)/lzo.do_compile: $(DEPDIR)/lzo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_lzo) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--enable-shared \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/lzo: $(DEPDIR)/lzo.do_compile
	$(start_build)
	cd $(DIR_lzo) && \
		$(INSTALL_lzo)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# yajl
#
BEGIN[[
yajl
  2.0.1
  {PN}-{PV}
  nothing:git://github.com/lloyd/{PN}:r=f4b2b1af87483caac60e50e5352fc783d9b2de2d
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_yajl = "Yet Another JSON Library"
PKGR_yajl = r1
FILES_yajl = \
/usr/lib/libyajl.* \
/usr/bin/json*

$(DEPDIR)/yajl.do_prepare: bootstrap $(DEPENDS_yajl)
	$(PREPARE_yajl)
	touch $@

$(DEPDIR)/yajl.do_compile: $(DEPDIR)/yajl.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_yajl) && \
	$(BUILDENV) \
	./configure \
		--prefix=/usr && \
	sed -i "s/install: all/install: distro/g" Makefile && \
	$(MAKE) distro
	touch $@

$(DEPDIR)/yajl: $(DEPDIR)/yajl.do_compile
	$(start_build)
	cd $(DIR_yajl) && \
		$(INSTALL_yajl)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libpcre (shouldn't this be named pcre without the lib?)
#
BEGIN[[
libpcre
  8.30
  pcre-{PV}
  extract:ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libpcre = "Perl-compatible regular expression library"

FILES_libpcre = \
/usr/lib/* \
/usr/bin/pcre*

$(DEPDIR)/libpcre.do_prepare: bootstrap $(DEPENDS_libpcre)
	$(PREPARE_libpcre)
	touch $@

$(DEPDIR)/libpcre.do_compile: $(DEPDIR)/libpcre.do_prepare
	cd $(DIR_libpcre) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--enable-utf8 \
		--enable-unicode-properties && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libpcre: $(DEPDIR)/libpcre.do_compile
	$(start_build)
	cd $(DIR_libpcre) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < pcre-config > $(crossprefix)/bin/pcre-config && \
		chmod 755 $(crossprefix)/bin/pcre-config && \
		$(INSTALL_libpcre)
		rm -f $(targetprefix)/usr/bin/pcre-config
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# jasper
#
BEGIN[[
jasper
  1.900.1
  {PN}-{PV}
  extract:http://www.ece.uvic.ca/~mdadams/{PN}/software/{PN}-{PV}.zip
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_jasper = "JasPer is a collection \
of software (i.e., a library and application programs) for the coding \
and manipulation of images.  This software can handle image data in a \
variety of formats"

FILES_jasper = \
/usr/bin/* 

$(DEPDIR)/jasper.do_prepare: bootstrap $(DEPENDS_jasper)
	$(PREPARE_jasper)
	touch $@

$(DEPDIR)/jasper.do_compile: $(DEPDIR)/jasper.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_jasper) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/jasper: $(DEPDIR)/jasper.do_compile
	$(start_build)
	cd $(DIR_jasper) && \
		$(INSTALL_jasper)
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# rarfs
#
BEGIN[[
rarfs
  0.1.1
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_rarfs = ""

FILES_rarfs = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/rarfs.do_prepare: bootstrap libstdc++-dev fuse $(DEPENDS_rarfs)
	$(PREPARE_rarfs)
	touch $@

$(DEPDIR)/rarfs.do_compile: $(DEPDIR)/rarfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_rarfs) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os -D_FILE_OFFSET_BITS=64" \
	./configure \
		--host=$(target) \
		--disable-option-checking \
		--includedir=/usr/include/fuse \
		--prefix=/usr
	touch $@

$(DEPDIR)/rarfs: $(DEPDIR)/rarfs.do_compile
	$(start_build)
	cd $(DIR_rarfs) && \
		$(INSTALL_rarfs)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# sshfs
#
BEGIN[[
sshfs
  2.4
  {PN}-fuse-{PV}
  extract:http://fossies.org/linux/misc/{PN}-fuse-{PV}.tar.bz2
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/sshfs.do_prepare: bootstrap fuse $(DEPENDS_sshfs)
	$(PREPARE_sshfs)
	touch $@

$(DEPDIR)/sshfs.do_compile: $(DEPDIR)/sshfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_sshfs) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/sshfs: $(DEPDIR)/sshfs.do_compile
	cd $(DIR_sshfs) && \
		$(INSTALL_sshfs)
	touch $@

#
# gmediarender
#
BEGIN[[
gmediarender
  0.0.6
  {PN}-{PV}
  extract:http://savannah.nongnu.org/download/gmrender/{PN}-{PV}.tar.bz2
  patch:file://{PN}.patch
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/gmediarender.do_prepare: bootstrap libstdc++-dev gst_plugins_dvbmediasink libupnp $(DEPENDS_gmediarender)
	$(PREPARE_gmediarender)
	touch $@

$(DEPDIR)/gmediarender.do_compile: $(DEPDIR)/gmediarender.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gmediarender) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-libupnp=$(targetprefix)/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/gmediarender: $(DEPDIR)/gmediarender.do_compile
	cd $(DIR_gmediarender) && \
		$(INSTALL_gmediarender)
	touch $@


#
# e2-rtmpgw
#
BEGIN[[
e2_rtmpgw
  git
  {PN}
  git://github.com/zakalibit/e2-rtmpgw.git:b=gw-e2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_e2_rtmpgw = A toolkit for RTMP streams
PKGR_e2_rtmpgw = r1
FILES_e2_rtmpgw = \
/usr/sbin/rtmpgw2

$(DEPDIR)/e2_rtmpgw.do_prepare: bootstrap openssl openssl-dev libz $(DEPENDS_e2_rtmpgw)
	$(PREPARE_e2_rtmpgw)
	touch $@

$(DEPDIR)/e2_rtmpgw.do_compile: $(DEPDIR)/e2_rtmpgw.do_prepare
	cd $(DIR_e2_rtmpgw) && \
	$(BUILDENV) \
	$(MAKE) all
	touch $@

$(DEPDIR)/e2_rtmpgw: $(DEPDIR)/e2_rtmpgw.do_compile
	$(start_build)
	cd $(DIR_e2_rtmpgw) && \
		$(INSTALL_e2_rtmpgw)
	$(tocdk_build)
	$(toflash_build)
	touch $@
