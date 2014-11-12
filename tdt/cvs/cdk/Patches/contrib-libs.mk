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
