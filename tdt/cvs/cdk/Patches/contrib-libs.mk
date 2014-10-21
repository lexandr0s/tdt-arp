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
# libz
#
BEGIN[[
libz
  1.2.8
  zlib-{PV}
  extract:http://zlib.net/zlib-{PV}.tar.gz
  patch:file://zlib-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END
NAME_libz = libz1
DESCRIPTION_libz = Zlib Compression Library Zlib is a general-purpose, patent-free, lossless data compression library \
which is used by many different programs.
FILES_libz = \
/usr/lib/*

LIBZ_ORDER = binutils-dev

$(DEPDIR)/libz.do_prepare: bootstrap $(DEPENDS_libz) $(if $(LIBZ_ORDER),| $(LIBZ_ORDER))
	$(PREPARE_libz)
	touch $@

$(DEPDIR)/libz.do_compile: $(DEPDIR)/libz.do_prepare
	cd $(DIR_libz) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--shared && \
		$(MAKE)
	touch $@

$(DEPDIR)/libz: $(DEPDIR)/libz.do_compile
	$(start_build)
	cd $(DIR_libz) && \
		$(INSTALL_libz)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libreadline
#
BEGIN[[
libreadline
  6.2
  readline-{PV}
  extract:ftp://ftp.cwru.edu/pub/bash/readline-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libreadline = libreadline6
DESCRIPTION_libreadline = Library for editing typed command lines \
 The GNU Readline library provides a set of functions for use by \
 applications that allow users to edit command lines as they are typed in. \
 Both Emacs and vi editing modes are available. The Readline library \
 includes  additional functions to maintain a list of previously-entered \
 command lines, to recall and perhaps reedit those   lines, and perform \
 csh-like history expansion on previous commands.
RDEPENDS_libreadline += libncurses5 libc6
define postinst_libreadline
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libreadline = \
/usr/lib

$(DEPDIR)/libreadline.do_prepare: bootstrap ncurses ncurses-dev $(DEPENDS_libreadline)
	$(PREPARE_libreadline)
	touch $@

$(DEPDIR)/libreadline.do_compile: $(DEPDIR)/libreadline.do_prepare
	cd $(DIR_libreadline) && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libreadline: $(DEPDIR)/libreadline.do_compile
	$(start_build)
	cd $(DIR_libreadline) && \
		$(INSTALL_libreadline)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# FREETYPE_OLD
#
BEGIN[[
freetype_old
  2.1.4
  freetype-{PV}
  extract:file://freetype-{PV}.tar.bz2
  patch:file://libfreetype.diff
  make:install:DESTDIR=BUILD/freetype-{PV}/install_dir
;
]]END

$(DEPDIR)/freetype-old.do_prepare: bootstrap $(DEPENDS_freetype_old)
	$(PREPARE_freetype_old)
	touch $@

$(DEPDIR)/freetype-old.do_compile: $(DEPDIR)/freetype-old.do_prepare
	cd $(DIR_freetype_old) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/freetype-old: $(DEPDIR)/freetype-old.do_compile
	cd $(DIR_freetype_old) && \
		$(INSTALL_freetype_old)
	cd freetype-2.1.4; \
		$(INSTALL_DIR) $(crossprefix)/bin; \
		cp install_dir/usr/bin/freetype-config $(crossprefix)/bin/freetype-old-config; \
		$(INSTALL_DIR) $(targetprefix)/usr/include/freetype-old; \
		$(CP_RD) install_dir/usr/include/* $(targetprefix)/usr/include/freetype-old/; \
		$(INSTALL_DIR) $(targetprefix)/usr/lib/freetype-old; \
		$(CP_RD) install_dir/usr/lib/libfreetype.{a,so*} $(targetprefix)/usr/lib/freetype-old/; \
		sed 's,-I$${prefix}/include/freetype2,-I$(targetprefix)/usr/include/freetype-old -I$(targetprefix)/usr/include/freetype-old/freetype2,g' -i $(crossprefix)/bin/freetype-old-config; \
		sed 's,/usr/include/freetype2/,$(targetprefix)/usr/include/freetype-old/freetype2/,g' -i $(crossprefix)/bin/freetype-old-config
	touch $@

#
# freetype
#
BEGIN[[
freetype
  2.4.9
  {PN}-{PV}
  extract:http://download.savannah.gnu.org/releases/{PN}/{PN}-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_freetype = libfreetype6
DESCRIPTION_freetype = Freetype font rendering library \
 FreeType is a software font engine that is designed to be small, \
 efficient, highly customizable, and portable while capable of producing \
 high-quality output (glyph images). It can be used in graphics libraries, \
 display servers, font conversion tools, text image generation tools, and \
 many other products as well.
RDEPENDS_freetype = libc6
FILES_freetype = /usr/lib/*.so*
#/usr/bin/freetype-config

$(DEPDIR)/freetype.do_prepare: bootstrap $(DEPENDS_freetype)
	$(PREPARE_freetype)
	touch $@

$(DEPDIR)/freetype.do_compile: $(DEPDIR)/freetype.do_prepare
	cd $(DIR_freetype) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/freetype: $(DEPDIR)/freetype.do_compile
	$(start_build)
	cd $(DIR_freetype) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < builds/unix/freetype-config > $(crossprefix)/bin/freetype-config && \
		chmod 755 $(crossprefix)/bin/freetype-config && \
		ln -sf $(crossprefix)/bin/freetype-config $(crossprefix)/bin/$(target)-freetype-config && \
		ln -sf $(targetprefix)/usr/include/freetype2/freetype $(targetprefix)/usr/include/freetype && \
		$(INSTALL_freetype)
		rm -f $(targetprefix)/usr/bin/freetype-config
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# lirc
#
BEGIN[[
lirc
  0.9.0
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}-try_first_last_remote.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lirc ="lirc"
PKGR_lirc = r3
FILES_lirc = \
/usr/bin/lircd \
/usr/lib/*.so* \
/etc/lircd*
ifeq ($(ENABLE_SPARK)$(ENABLE_SPARK7162),yes)
define conffiles_lirc
/etc/lircd.conf
/etc/lircd.conf.09_00_0B
/etc/lircd.conf.09_00_07
/etc/lircd.conf.09_00_08
/etc/lircd.conf.09_00_1D
endef
else
define conffiles_lirc
/etc/lircd.conf
endef
endif

$(DEPDIR)/lirc.do_prepare: bootstrap $(DEPENDS_lirc)
	$(PREPARE_lirc)
	touch $@

$(DEPDIR)/lirc.do_compile: $(DEPDIR)/lirc.do_prepare
	cd $(DIR_lirc) && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -Os -D__KERNEL_STRICT_NAMES" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--mandir=\$${prefix}/share/man \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-devdir=/dev \
			--with-moduledir=/lib/modules \
			--with-major=61 \
			--with-driver=userspace \
			--enable-debug \
			--with-syslog=LOG_DAEMON \
			--enable-sandboxed && \
		$(MAKE) all
	touch $@

$(DEPDIR)/lirc: $(DEPDIR)/lirc.do_compile
	$(start_build)
	cd $(DIR_lirc) && \
		$(INSTALL_lirc)
	$(INSTALL_DIR) $(PKDIR)/etc
	$(INSTALL_DIR) $(PKDIR)/var/run/lirc/
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd$(if $(HL101),_$(HL101))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)).conf $(PKDIR)/etc/lircd.conf
ifeq ($(ENABLE_SPARK)$(ENABLE_SPARK7162),yes)
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_0B $(PKDIR)/etc/lircd.conf.09_00_0B && \
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_07 $(PKDIR)/etc/lircd.conf.09_00_07 && \
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_08 $(PKDIR)/etc/lircd.conf.09_00_08 && \
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_1D $(PKDIR)/etc/lircd.conf.09_00_1D
endif
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libjpeg
#
BEGIN[[
libjpeg
  8d
  jpeg-{PV}
  extract:http://www.ijg.org/files/jpegsrc.v{PV}.tar.gz
  patch:file://jpeg.diff
  make:install:DESTDIR=PKDIR
;
]]END
NAME_libjpeg = libjpeg8
DESCRIPTION_libjpeg = libjpeg contains a library for handling the JPEG (JFIF) image format, as \
 well as related programs for accessing the libjpeg functions.
RDEPENDS_libjpeg = libc6
FILES_libjpeg = \
/usr/lib/*.so* 

$(DEPDIR)/libjpeg.do_prepare: bootstrap $(DEPENDS_libjpeg)
	$(PREPARE_libjpeg)
	touch $@

$(DEPDIR)/libjpeg.do_compile: $(DEPDIR)/libjpeg.do_prepare
	cd $(DIR_libjpeg) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--enable-static \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libjpeg: $(DEPDIR)/libjpeg.do_compile
	$(start_build)
	cd $(DIR_libjpeg) && \
		$(INSTALL_libjpeg)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libpng
#
BEGIN[[
libpng
  1.6.10
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/libpng/{PN}-{PV}.tar.gz
  nothing:file://{PN}.diff
  patch:file://{PN}-workaround_for_stmfb_alpha_error.patch
  make:install:prefix=PKDIR/usr
;
]]END

PACKAGES_libpng = libpng16
DESCRIPTION_libpng16 = "libpng"
RDEPENDS_libpng16 = libz1 libc6
FILES_libpng16 = /usr/lib/*.so*

$(DEPDIR)/libpng.do_prepare: bootstrap libz $(DEPENDS_libpng)
	$(PREPARE_libpng)
	touch $@

$(DEPDIR)/libpng.do_compile: $(DEPDIR)/libpng.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libpng) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-maintainer-mode \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libpng: $(DEPDIR)/libpng.do_compile
	$(start_build)
	cd $(DIR_libpng) && \
		sed -e "s,^prefix=,prefix=$(PKDIR)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		$(INSTALL_libpng)
		rm -f $(PKDIR)/usr/bin/libpng*-config
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libpng12
#
BEGIN[[
libpng12
  1.2.49
  libpng-{PV}
  extract:http://ftp.de.debian.org/debian/pool/main/libp/libpng/libpng_{PV}.orig.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libpng12 = "libpng12"
RDEPENDS_libpng12 += libz1 libc6

FILES_libpng12 = \
/usr/lib/libpng12.so*

$(DEPDIR)/libpng12.do_prepare: bootstrap $(DEPENDS_libpng12)
	$(PREPARE_libpng12)
	touch $@

$(DEPDIR)/libpng12.do_compile: $(DEPDIR)/libpng12.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libpng12) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libpng12: $(DEPDIR)/libpng12.do_compile
	$(start_build)
	cd $(DIR_libpng12) && \
		sed -e "s,^prefix=,prefix=$(PKDIR)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		$(INSTALL_libpng)
		rm -f $(PKDIR)/usr/bin/libpng*-config
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libungif
#
BEGIN[[
libungif
  4.1.4
  {PN}-{PV}
  extract:http://heanet.dl.sourceforge.net/sourceforge/giflib/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libungif = "libungif"
NAME_libungif = libungif4
RDEPENDS_libungif = libc6
FILES_libungif = \
/usr/lib/*.so*

$(DEPDIR)/libungif.do_prepare: bootstrap $(DEPENDS_libungif)
	$(PREPARE_libungif)
	touch $@

$(DEPDIR)/libungif.do_compile: $(DEPDIR)/libungif.do_prepare
	cd $(DIR_libungif) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libungif: $(DEPDIR)/libungif.do_compile
	$(start_build)
	cd $(DIR_libungif) && \
		$(INSTALL_libungif)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libgif
#
BEGIN[[
libgif
  4.1.6
  giflib-{PV}
  extract:http://heanet.dl.sourceforge.net/sourceforge/giflib/giflib-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END
NAME_libgif = libgif4
DESCRIPTION_libgif =  shared library for GIF images

FILES_libgif = \
/usr/lib/*.so*

$(DEPDIR)/libgif.do_prepare: bootstrap $(DEPENDS_libgif)
	$(PREPARE_libgif)
	touch $@

$(DEPDIR)/libgif.do_compile: $(DEPDIR)/libgif.do_prepare
	cd $(DIR_libgif) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libgif: $(DEPDIR)/libgif.do_compile
	$(start_build)
	cd $(DIR_libgif) && \
		$(INSTALL_libgif)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libcurl
#
BEGIN[[
curl
  7.34.0
  {PN}-{PV}
  extract:http://{PN}.haxx.se/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_curl = Command line tool and library for client-side URL transfers
PACKAGES_curl = libcurl4 \
		curl

DESCRIPTION_libcurl4 = Command line tool and library for client-side URL transfers
RDEPENDS_libcurl4 = libcap2 libz1 librtmp1 libc6
define postinst_libcurl4
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcurl4 = /usr/lib/*.so*

DESCRIPTION_curl = Command line tool and library for client-side URL transfers
RDEPENDS_curl = libcurl4 libz1 libc6
FILES_curl = /usr/bin/curl

$(DEPDIR)/curl.do_prepare: bootstrap openssl rtmpdump libcap libz $(DEPENDS_curl)
	$(PREPARE_curl)
	touch $@

$(DEPDIR)/curl.do_compile: $(DEPDIR)/curl.do_prepare
	cd $(DIR_curl) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-ssl \
			--disable-debug \
			--disable-verbose \
			--disable-manual \
			--mandir=/usr/share/man \
			--with-random && \
		$(MAKE) all
	touch $@

$(DEPDIR)/curl: $(DEPDIR)/curl.do_compile
	$(start_build)
	cd $(DIR_curl) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(crossprefix)/bin/curl-config && \
		chmod 755 $(crossprefix)/bin/curl-config && \
		$(INSTALL_curl)
		rm -f $(PKDIR)/usr/bin/curl-config
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libfribidi
#
BEGIN[[
libfribidi
  0.19.5
  fribidi-{PV}
  extract:http://fribidi.org/download/fribidi-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END
PACKAGES_libfribidi = libfribidi0 \
		      libfribidi_bin
DESCRIPTION_libfribidi0 = Fribidi library for bidirectional text
RDEPENDS_libfribidi0 = libc6
FILES_libfribidi0 = /usr/lib/*.so*

DESCRIPTION_libfribidi_bin = Fribidi library for bidirectional text
RDEPENDS_libfribidi_bin = libfribidi0 libc6
FILES_libfribidi_bin = /usr/bin/*

$(DEPDIR)/libfribidi.do_prepare: bootstrap $(DEPENDS_libfribidi)
	$(PREPARE_libfribidi)
	touch $@

$(DEPDIR)/libfribidi.do_compile: $(DEPDIR)/libfribidi.do_prepare
	cd $(DIR_libfribidi) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-memopt && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libfribidi: $(DEPDIR)/libfribidi.do_compile
	$(start_build)
	cd $(DIR_libfribidi) && \
		$(INSTALL_libfribidi)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libsigc
#
BEGIN[[
libsigc
  1.2.7
  {PN}++-{PV}
  extract:http://ftp.gnome.org/pub/GNOME/sources/{PN}++/1.2/{PN}++-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libsigc = libsigc_1.2
DESCRIPTION_libsigc =  A library for loose coupling of C++ method calls
RDEPENDS_libsigc = libstdc++6 libgcc1
FILES_libsigc = /usr/lib/*.so*

$(DEPDIR)/libsigc.do_prepare: bootstrap libstdc++ libstdc++-dev $(DEPENDS_libsigc)
	$(PREPARE_libsigc)
	touch $@

$(DEPDIR)/libsigc.do_compile: $(DEPDIR)/libsigc.do_prepare
	cd $(DIR_libsigc) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libsigc: $(DEPDIR)/libsigc.do_compile
	$(start_build)
	cd $(DIR_libsigc) && \
		$(INSTALL_libsigc)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libmad
#
BEGIN[[
libmad
  0.15.1b
  {PN}-{PV}
  extract:ftp://ftp.mars.org/pub/mpeg/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmad = "libmad - MPEG audio decoder library"
NAME_libmad = libmad0
RDEPENDS_libmad = libc6
FILES_libmad = \
/usr/lib/*.so*

$(DEPDIR)/libmad.do_prepare: bootstrap $(DEPENDS_libmad)
	$(PREPARE_libmad)
	touch $@

$(DEPDIR)/libmad.do_compile: $(DEPDIR)/libmad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmad) && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		autoheader && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debugging \
			--enable-shared=yes \
			--enable-speed \
			--enable-sso && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libmad: $(DEPDIR)/libmad.do_compile
	$(start_build)
	cd $(DIR_libmad) && \
		$(INSTALL_libmad)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libid3tag
#
BEGIN[[
libid3tag
  0.15.1b
  {PN}-{PV}
  extract:ftp://ftp.mars.org/pub/mpeg/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libid3tag = Library for interacting with ID3 tags in MP3 files  Library for \
 interacting with ID3 tags in MP3 files.
NAME_libid3tag = libid3tag0
RDEPENDS_libid3tag = libz1 libc6

FILES_libid3tag = \
/usr/lib/*.so*

$(DEPDIR)/libid3tag.do_prepare: bootstrap libz $(DEPENDS_libid3tag)
	$(PREPARE_libid3tag)
	touch $@

$(DEPDIR)/libid3tag.do_compile: $(DEPDIR)/libid3tag.do_prepare
	cd $(DIR_libid3tag) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared=yes && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libid3tag: $(DEPDIR)/libid3tag.do_compile
	$(start_build)
	cd $(DIR_libid3tag) && \
		$(INSTALL_libid3tag)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libvorbisidec
#
BEGIN[[
libvorbisidec
  1.0.2+svn16259
  {PN}-{PV}
  extract:http://ftp.debian.org/debian/pool/main/libv/{PN}/{PN}_{PV}.orig.tar.gz
  patch:file://tremor.diff
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libvorbisidec = Fixed-point decoder - Development files (Static Libraries)  tremor is a \
 fixed point implementation of the vorbis codec.  This package contains static libraries for software development.
NAME_libvorbisidec = libvorbisidec1
RDEPENDS_libvorbisidec = libogg0 libc6
FILES_libvorbisidec = \
/usr/lib/*.so*

$(DEPDIR)/libvorbisidec.do_prepare: bootstrap $(DEPENDS_libvorbisidec)
	$(PREPARE_libvorbisidec)
	touch $@

$(DEPDIR)/libvorbisidec.do_compile: $(DEPDIR)/libvorbisidec.do_prepare
	cd $(DIR_libvorbisidec) && \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libvorbisidec: $(DEPDIR)/libvorbisidec.do_compile
	$(start_build)
	cd $(DIR_libvorbisidec) && \
		$(INSTALL_libvorbisidec)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libffi
#
BEGIN[[
libffi
  3.0.13
  {PN}-{PV}
  extract:ftp://sourceware.org/pub/{PN}/{PN}-{PV}.tar.gz
  patch:file://libffi-3.0.11.patch
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libffi = libffi6
DESCRIPTION_libffi = A portable foreign function interface library \
 The `libffi' library provides a portable, high level programming \
 interface to various calling conventions.  This allows a programmer to \
 call any function specified by a call interface description at run time. \
 FFI stands for Foreign Function Interface.  A foreign function interface \
 is the popular name for the interface that allows code written in one \
 language to call code written in another language.  The `libffi' library \
 really only provides the lowest, machine dependent layer of a fully \
 featured foreign function interface.  A layer must exist above `libffi' \
 that handles type conversions for values passed between the two languages.
RDEPENDS_libffi = libc6
FILES_libffi = \
/usr/lib/libffi.so*

$(DEPDIR)/libffi.do_prepare: bootstrap libjpeg lcms $(DEPENDS_libffi)
	$(PREPARE_libffi)
	touch $@

$(DEPDIR)/libffi.do_compile: $(DEPDIR)/libffi.do_prepare
	cd $(DIR_libffi) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--disable-static \
			--enable-builddir=libffi \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libffi: $(DEPDIR)/libffi.do_compile
	$(start_build)
	cd $(DIR_libffi) && \
		$(INSTALL_libffi)
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# libglib2
# You need libglib2.0-dev on host system
#
BEGIN[[
glib2
  2.34.3
  glib-{PV}
  extract:http://ftp.gnome.org/pub/GNOME/sources/glib/2.34/glib-{PV}.tar.xz
  patch:file://glib-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

NAME_glib2 = libglib

DESCRIPTION_glib2 = A general-purpose utility library GLib is a general-purpose \
utility library, which provides many useful data types, macros, type conversions, \
string utilities, file utilities, a main loop abstraction, and so on
RDEPENDS_glib2 = libffi6 libz1 libc6
FILES_glib2 = /usr/lib/libgio-2.0.so.* \
	      /usr/lib/libglib-2.0.so.* \
	      /usr/lib/libgmodule-2.0.so.* \
	      /usr/lib/libgobject-2.0.so.* \
	      /usr/lib/libgthread-2.0.so.* \
	      /usr/lib/gio/modules \
	      /usr/share/glib-2.0/schemas/gschema.dtd

$(DEPDIR)/glib2.do_prepare: bootstrap libz libffi $(DEPENDS_glib2)
	$(PREPARE_glib2)
	touch $@

$(DEPDIR)/glib2.do_compile: $(DEPDIR)/glib2.do_prepare
	echo "glib_cv_va_copy=no" > $(DIR_glib2)/config.cache
	echo "glib_cv___va_copy=yes" >> $(DIR_glib2)/config.cache
	echo "glib_cv_va_val_copy=yes" >> $(DIR_glib2)/config.cache
	echo "ac_cv_func_posix_getpwuid_r=yes" >> $(DIR_glib2)/config.cache
	echo "ac_cv_func_posix_getgrgid_r=yes" >> $(DIR_glib2)/config.cache
	echo "glib_cv_stack_grows=no" >> $(DIR_glib2)/config.cache
	echo "glib_cv_uscore=no" >> $(DIR_glib2)/config.cache
	cd $(DIR_glib2) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--cache-file=config.cache \
			--disable-gtk-doc \
			--with-threads="posix" \
			--enable-static \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) all
	touch $@

$(DEPDIR)/glib2: $(DEPDIR)/glib2.do_compile
	$(start_build)
	cd $(DIR_glib2) && \
		$(INSTALL_glib2)
	$(tocdk_build)
	$(toflash_build)
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
		CFLAGS="$(TARGET_CFLAGS) -g3" \
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

#
# expat
#
BEGIN[[
expat
  2.1.0
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_expat = libexpat1 \
		 libexpat_bin

DESCRIPTION_libexpat1 = Expat is an XML parser library written in C. It is a stream-oriented parser \
in which an application registers handlers for things the parser might find in the XML document
RDEPENDS_libexpat1 = libc6
define postinst_libexpat1
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libexpat1 = /usr/lib/libexpat.so*

DESCRIPTION_libexpat_bin = Expat is an XML parser library written in C. It is a stream-oriented parser \
in which an application registers handlers for things the parser might find in the XML document
RDEPENDS_libexpat_bin = libexpat1 libc6
FILES_libexpat_bin = /usr/bin/xmlwf

$(DEPDIR)/expat.do_prepare: bootstrap $(DEPENDS_expat)
	$(PREPARE_expat)
	touch $@

$(DEPDIR)/expat.do_compile: $(DEPDIR)/expat.do_prepare
	cd $(DIR_expat) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/expat: $(DEPDIR)/expat.do_compile
	$(start_build)
	cd $(DIR_expat) && \
		$(INSTALL_expat)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# fontconfig
#
BEGIN[[
fontconfig
  2.10.2
  {PN}-{PV}
  extract:http://{PN}.org/release/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_fontconfig = libfontconfig1 \
		      fontconfig_utils

DESCRIPTION_libfontconfig1 = Generic font configuration library \
 Fontconfig is a font configuration and customization library, which does \
 not depend on the X Window System. It is designed to locate fonts within \
 the system and select them according to requirements specified by \
 applications. Fontconfig is not a rasterization library, nor does it \
 impose a particular rasterization library on the application. The \
 X-specific library 'Xft' uses fontconfig along with freetype to specify \
 and rasterize fonts.
RDEPENDS_libfontconfig1 = libexpat1 libfreetype6 libc6
define postinst_libfontconfig1
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libfontconfig1 = \
	/etc/fonts/* \
	/usr/lib/* \
	/usr/share/* \
	/var/cache/*

DESCRIPTION_fontconfig_utils = Generic font configuration library \
 Fontconfig is a font configuration and customization library, which does \
 not depend on the X Window System. It is designed to locate fonts within \
 the system and select them according to requirements specified by \
 applications. Fontconfig is not a rasterization library, nor does it \
 impose a particular rasterization library on the application. The \
 X-specific library 'Xft' uses fontconfig along with freetype to specify \
 and rasterize fonts.
RDEPENDS_fontconfig_utils = libfreetype6 libc6 libfontconfig1
FILES_fontconfig_utils = /usr/bin/*

$(DEPDIR)/fontconfig.do_prepare: bootstrap libz libxml2 freetype expat $(DEPENDS_fontconfig)
	$(PREPARE_fontconfig)
	touch $@

$(DEPDIR)/fontconfig.do_compile: $(DEPDIR)/fontconfig.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_fontconfig) && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os -I$(targetprefix)/usr/include/libxml2" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-arch=sh4 \
			--with-freetype-config=$(crossprefix)/bin/freetype-config \
			--with-expat-includes=$(targetprefix)/usr/include \
			--with-expat-lib=$(targetprefix)/usr/lib \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-docs \
			--without-add-fonts && \
		$(MAKE)
	touch $@

$(DEPDIR)/fontconfig: $(DEPDIR)/fontconfig.do_compile
	$(start_build)
	cd $(DIR_fontconfig) && \
		$(INSTALL_fontconfig)
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# libxml2
#
BEGIN[[
libxml2
  2.7.8
  {PN}-{PV}
  extract:http://xmlsoft.org/sources/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libxml2 = XML C Parser Library and Toolkit \
 The XML Parser Library allows for manipulation of XML files.  Libxml2 \
 exports Push and Pull type parser interfaces for both XML and HTML.  It \
 can do DTD validation at parse time, on a parsed document instance or \
 with an arbitrary DTD.  Libxml2 includes complete XPath, XPointer and \
 Xinclude implementations.  It also has a SAX like interface, which is \
 designed to be compatible with Expat.
RDEPENDS_libxml2 = libz1 libc6
define postinst_libxml2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libxml2 = /usr/bin/xmlcatalog   /usr/bin/xmllint /usr/lib/libxml2.*

$(DEPDIR)/libxml2.do_prepare: bootstrap libz $(DEPENDS_libxml2)
	$(PREPARE_libxml2)
	touch $@

$(DEPDIR)/libxml2.do_compile: $(DEPDIR)/libxml2.do_prepare
	cd $(DIR_libxml2) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--with-python=$(crossprefix)/bin \
			--without-c14n \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all 
	touch $@

$(DEPDIR)/libxml2: $(DEPDIR)/libxml2.do_compile
	$(start_build)
	cd $(DIR_libxml2) && \
		$(INSTALL_libxml2) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config && \
		chmod 755 $(crossprefix)/bin/xml2-config
	$(tocdk_build_start)
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(ipkgbuilddir)/libxml2/usr/lib/xml2Conf.sh
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(ipkgbuilddir)/libxml2/usr/lib/xml2Conf.sh
	$(call do_build_pkg,install,cdk)
	$(toflash_build)
	touch $@

#
# libxmlccwrap
#
BEGIN[[
libxmlccwrap
  0.0.12
  {PN}-{PV}
  extract:http://www.ant.uni-bremen.de/whomes/rinas/{PN}/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libxmlccwrap = "libxmlccwrap is a small C++ wrapper around libxml2 and libxslt "
RDEPENDS_libxmlccwrap += libgcc1 libxml2 libz1 libstdc++6 libc6 libxslt
define postinst_libxmlccwrap
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

FILES_libxmlccwrap = \
/usr/lib/*.so*

$(DEPDIR)/libxmlccwrap.do_prepare: bootstrap libxslt $(DEPENDS_libxmlccwrap)
	$(PREPARE_libxmlccwrap)
	touch $@

$(DEPDIR)/libxmlccwrap.do_compile: $(DEPDIR)/libxmlccwrap.do_prepare
	cd $(DIR_libxmlccwrap) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libxmlccwrap: libxmlccwrap.do_compile
	$(start_build)
	cd $(DIR_libxmlccwrap) && \
		$(INSTALL_libxmlccwrap) && \
		sed -e "/^dependency_libs/ s,-L/usr/lib,-L$(PKDIR)/usr/lib,g" -i $(PKDIR)/usr/lib/libxmlccwrap.la && \
		sed -e "/^dependency_libs/ s, /usr/lib, $(PKDIR)/usr/lib,g" -i $(PKDIR)/usr/lib/libxmlccwrap.la
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# a52dec
#
BEGIN[[
a52dec
  0.7.4
  {PN}-{PV}
  extract:http://liba52.sourceforge.net/files/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_a52dec = liba52 \
		  a52dec

DESCRIPTION_liba52 = "liba52 is a free library for decoding ATSC A/52 streams. It is released under the terms of the GPL license"
RDEPENDS_liba52 = libc6
define postinst_liba52
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_liba52 = /usr/lib/liba52.*

DESCRIPTION_a52dec = "liba52 is a free library for decoding ATSC A/52 streams. It is released under the terms of the GPL license"
RDEPENDS_a52dec = liba52 libc6
FILES_a52dec = /usr/bin/*

$(DEPDIR)/a52dec.do_prepare: bootstrap $(DEPENDS_a52dec)
	$(PREPARE_a52dec)
	touch $@

$(DEPDIR)/a52dec.do_compile: $(DEPDIR)/a52dec.do_prepare
	cd $(DIR_a52dec) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/a52dec: a52dec.do_compile
	$(start_build)
	cd $(DIR_a52dec) && \
		$(INSTALL_a52dec)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libdvdcss
#
BEGIN[[
libdvdcss
  1.2.12
  {PN}-{PV}
  extract:http://download.videolan.org/pub/{PN}/{PV}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libdvdcss = libdvdcss2
DESCRIPTION_libdvdcss = libdvdcss is a simple library designed for accessing DVDs like a block \
 device without having to bother about the decryption.
RDEPENDS_libdvdcss = libc6
define postinst_libdvdcss
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libdvdcss = \
/usr/lib/libdvdcss.so*

$(DEPDIR)/libdvdcss.do_prepare: bootstrap $(DEPENDS_libdvdcss)
	$(PREPARE_libdvdcss)
	touch $@

$(DEPDIR)/libdvdcss.do_compile: $(DEPDIR)/libdvdcss.do_prepare
	cd $(DIR_libdvdcss) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-doc \
		&& \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdcss: libdvdcss.do_compile
	$(start_build)
	cd $(DIR_libdvdcss) && \
		$(INSTALL_libdvdcss)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libdvdnav
#
BEGIN[[
libdvdnav
  4.1.3
  {PN}-{PV}
  extract:http://www.mplayerhq.hu/MPlayer/releases/dvdnav-old/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-3.diff
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_libdvdnav = libdvdnav4 \
		     libdvdnavmini4
DESCRIPTION_libdvdnav4 = DVD navigation multimeda library - Development files  DVD navigation \
 multimeda library.  This package contains symbolic links,   header files, \
 and related items necessary for software development.
RDEPENDS_libdvdnav4 = libdvdread4 libc6
define postinst_libdvdnav4
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libdvdnav4 = /usr/lib/libdvdnav.so*

DESCRIPTION_libdvdnavmini4 = DVD navigation multimeda library - Development files  DVD navigation \
 multimeda library.  This package contains symbolic links,   header files, \
 and related items necessary for software development.
RDEPENDS_libdvdnavmini4 = libc6
define postinst_libdvdnavmini4
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libdvdnavmini4 = /usr/lib/libdvdnavmini.so*

$(DEPDIR)/libdvdnav.do_prepare: bootstrap libdvdread $(DEPENDS_libdvdnav)
	$(PREPARE_libdvdnav)
	touch $@

$(DEPDIR)/libdvdnav.do_compile: $(DEPDIR)/libdvdnav.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdvdnav) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
			--with-dvdread-config=$(crossprefix)/bin/dvdread-config && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdnav: libdvdnav.do_compile
	 $(start_build)
	 cd $(DIR_libdvdnav) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdnav-config > $(crossprefix)/bin/dvdnav-config && \
		chmod 755 $(crossprefix)/bin/dvdnav-config && \
		$(INSTALL_libdvdnav)
		rm -f $(targetprefix)/usr/bin/dvdnav-config
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libdvdread
#
BEGIN[[
libdvdread
  4.1.3
  {PN}-{PV}
  extract:http://www.mplayerhq.hu/MPlayer/releases/dvdnav-old/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-5.diff
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libdvdread = libdvdread4
DESCRIPTION_libdvdread = "libdvdread"
RDEPENDS_libdvdread = libc6
define postinst_libdvdread
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libdvdread = /usr/lib/*.so*

$(DEPDIR)/libdvdread.do_prepare: bootstrap $(DEPENDS_libdvdread)
	$(PREPARE_libdvdread)
	touch $@

$(DEPDIR)/libdvdread.do_compile: $(DEPDIR)/libdvdread.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdvdread) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-static \
			--enable-shared \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdread: libdvdread.do_compile
	$(start_build)
	cd $(DIR_libdvdread) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdread-config > $(crossprefix)/bin/dvdread-config && \
		chmod 755 $(crossprefix)/bin/dvdread-config && \
		$(INSTALL_libdvdread)
		rm -f $(targetprefix)/usr/bin/dvdread-config
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# ffmpeg
#
BEGIN[[
ffmpeg
  2.1.3
  {PN}-{PV}
  extract:http://{PN}.org/releases/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_ffmpeg = "ffmpeg"
RDEPENDS_ffmpeg = libass librtmp1
FILES_ffmpeg = \
/usr/lib/*.so* \
/sbin/ffmpeg

$(DEPDIR)/ffmpeg.do_prepare: bootstrap libass rtmpdump $(DEPENDS_ffmpeg)
	$(PREPARE_ffmpeg)
	touch $@

$(DEPDIR)/ffmpeg.do_compile: $(DEPDIR)/ffmpeg.do_prepare
	cd $(DIR_ffmpeg) && \
	$(BUILDENV) \
	./configure \
		--disable-static \
		--enable-shared \
		--disable-runtime-cpudetect \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-doc \
		--disable-htmlpages \
		--disable-manpages \
		--disable-podpages \
		--disable-txtpages \
		--disable-asm \
		--disable-altivec \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmxext \
		--disable-sse \
		--disable-sse2 \
		--disable-sse3 \
		--disable-ssse3 \
		--disable-sse4 \
		--disable-sse42 \
		--disable-avx \
		--disable-fma4 \
		--disable-armv5te \
		--disable-armv6 \
		--disable-armv6t2 \
		--disable-vfp \
		--disable-neon \
		--disable-vis \
		--disable-inline-asm \
		--disable-yasm \
		--disable-mips32r2 \
		--disable-mipsdspr1 \
		--disable-mipsdspr2 \
		--disable-mipsfpu \
		--disable-fast-unaligned \
		--disable-muxers \
		--enable-muxer=flac \
		--enable-muxer=mp3 \
		--enable-muxer=h261 \
		--enable-muxer=h263 \
		--enable-muxer=h264 \
		--enable-muxer=image2 \
		--enable-muxer=mpeg1video \
		--enable-muxer=mpeg2video \
		--enable-muxer=ogg \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=mpeg1video \
		--enable-encoder=mpeg2video \
		--enable-encoder=png \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=dvbsub \
		--enable-decoder=flac \
		--enable-decoder=pcm_s16le \
		--enable-decoder=flv \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h263p \
		--enable-decoder=h264 \
		--enable-decoder=h264_crystalhd \
		--enable-decoder=iff_byterun1 \
		--enable-decoder=mjpeg \
		--enable-decoder=mp3 \
		--enable-decoder=mpegvideo \
		--enable-decoder=mpeg1video \
		--enable-decoder=mpeg2video \
		--enable-decoder=mpeg2video_crystalhd \
		--enable-decoder=mpeg4 \
		--enable-decoder=mpeg4_crystalhd \
		--enable-decoder=png \
		--enable-decoder=theora \
		--enable-decoder=vorbis \
		--enable-parser=mjpeg \
		--enable-demuxer=mjpeg \
		--enable-demuxer=wav \
		--enable-demuxer=hls \
		--enable-protocol=file \
		--enable-protocol=hls \
		--enable-protocol=udp \
		--disable-indevs \
		--disable-outdevs \
		--enable-avresample \
		--enable-pthreads \
		--enable-bzlib \
		--disable-zlib \
		--disable-bsfs \
		--enable-librtmp \
		--pkg-config="pkg-config" \
		--disable-parser=hevc \
		--enable-cross-compile \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--disable-debug \
		--extra-cflags="-fno-strict-aliasing" \
		--enable-stripping \
		--prefix=/usr
	touch $@

$(DEPDIR)/ffmpeg: $(DEPDIR)/ffmpeg.do_compile
	$(start_build)
	cd $(DIR_ffmpeg) && \
		$(INSTALL_ffmpeg)
	$(tocdk_build)
	mv $(PKDIR)/usr/bin $(PKDIR)/sbin
	$(toflash_build)
	touch $@

#
# libass
#
BEGIN[[
libass
  0.10.2
  {PN}-{PV}
  extract:http://{PN}.googlecode.com/files/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libass = "libass"
RDEPENDS_libass += libfreetype6 libfribidi0

FILES_libass = \
/usr/lib/*.so*

$(DEPDIR)/libass.do_prepare: bootstrap freetype libfribidi $(DEPENDS_libass)
	$(PREPARE_libass)
	touch $@

$(DEPDIR)/libass.do_compile: $(DEPDIR)/libass.do_prepare
	cd $(DIR_libass) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--disable-enca \
		--prefix=/usr
	touch $@

$(DEPDIR)/libass: $(DEPDIR)/libass.do_compile
	$(start_build)
	cd $(DIR_libass) && \
		$(INSTALL_libass)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
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
# sqlite
#
BEGIN[[
sqlite
  3.7.11
  {PN}-autoconf-3071100
  extract:http://www.{PN}.org/{PN}-autoconf-3071100.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

NAME_sqlite = libsqlite3
DESCRIPTION_sqlite = Embeddable SQL database engine \
 Embeddable SQL database engine.
RDEPENDS_sqlite = libc6
define postinst_sqlite
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_sqlite = /usr/lib/*.so*

$(DEPDIR)/sqlite.do_prepare: bootstrap $(DEPENDS_sqlite)
	$(PREPARE_sqlite)
	touch $@

$(DEPDIR)/sqlite.do_compile: $(DEPDIR)/sqlite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_sqlite) && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-tcl \
		--disable-debug
	touch $@

$(DEPDIR)/sqlite: $(DEPDIR)/sqlite.do_compile
	$(start_build)
	cd $(DIR_sqlite) && \
		$(INSTALL_sqlite)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libsoup
#
BEGIN[[
libsoup
  2.33.90
  {PN}-{PV}
  extract:http://download.gnome.org/sources/{PN}/2.33/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libsoup = An HTTP library implementation in C
RDEPENDS_libsoup = libz1 libxml2 libffi6 libsqlite3 libc6 libglib2
define postinst_libsoup
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libsoup = /usr/lib/*.so*

$(DEPDIR)/libsoup.do_prepare: bootstrap sqlite glib2 libffi libz $(DEPENDS_libsoup)
	$(PREPARE_libsoup)
	touch $@

$(DEPDIR)/libsoup.do_compile: $(DEPDIR)/libsoup.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libsoup) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-more-warnings \
		--without-gnome
	touch $@

$(DEPDIR)/libsoup: $(DEPDIR)/libsoup.do_compile
	$(start_build)
	cd $(DIR_libsoup) && \
		$(INSTALL_libsoup)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# pixman
#
BEGIN[[
pixman
  0.18.0
  {PN}-{PV}
  extract:http://cairographics.org/releases/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

NAME_pixman = libpixman
DESCRIPTION_pixman =  Pixman provides a library for manipulating pixel regions -- a set of Y-X \
 banded rectangles, image compositing using the Porter/Duff model and \
 implicit mask generation for geometric primitives including trapezoids, \
 triangles, and rectangles.
RDEPENDS_pixman = libc6
define postinst_pixman
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_pixman = /usr/lib/*.so*

$(DEPDIR)/pixman.do_prepare: bootstrap $(DEPENDS_pixman)
	$(PREPARE_pixman)
	touch $@

$(DEPDIR)/pixman.do_compile: $(DEPDIR)/pixman.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_pixman) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/pixman: $(DEPDIR)/pixman.do_compile
	$(start_build)
	cd $(DIR_pixman) && \
		$(INSTALL_pixman)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# cairo
#
BEGIN[[
cairo
  1.8.10
  {PN}-{PV}
  extract:http://{PN}graphics.org/releases/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_cairo = "Cairo - Multi-platform 2D graphics library"

FILES_cairo = \
/usr/lib/*.so*

$(DEPDIR)/cairo.do_prepare: bootstrap libpng pixman $(DEPENDS_cairo)
	$(PREPARE_cairo)
	touch $@

$(DEPDIR)/cairo.do_compile: $(DEPDIR)/cairo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_cairo) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-gtk-doc \
		--enable-ft=yes \
		--enable-png=yes \
		--enable-ps=no \
		--enable-pdf=no \
		--enable-svg=no \
		--disable-glitz \
		--disable-xcb \
		--disable-xlib \
		--enable-directfb \
		--program-suffix=-directfb
	touch $@

$(DEPDIR)/cairo: $(DEPDIR)/cairo.do_compile
	$(start_build)
	cd $(DIR_cairo) && \
		$(INSTALL_cairo)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libogg
#
BEGIN[[
libogg
  1.3.0
  {PN}-{PV}
  extract:http://downloads.xiph.org/releases/ogg/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libogg = libogg0
DESCRIPTION_libogg = libogg is the bitstream and framing library for the Ogg project.\
It provides functions which are necessary to codec libraries like libvorbis.

FILES_libogg = \
/usr/lib/*.so*

$(DEPDIR)/libogg.do_prepare: bootstrap $(DEPENDS_libogg)
	$(PREPARE_libogg)
	touch $@

$(DEPDIR)/libogg.do_compile: $(DEPDIR)/libogg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libogg) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/libogg: $(DEPDIR)/libogg.do_compile
	$(start_build)
	cd $(DIR_libogg) && \
		$(INSTALL_libogg)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libflac
#
BEGIN[[
libflac
  1.2.1
  flac-{PV}
  extract:http://ignum.dl.sourceforge.net/project/flac/flac-src/flac-{PV}-src/flac-{PV}.tar.gz
  patch:file://flac-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_libflac = libflac8 \
		   libflacpp6
DESCRIPTION_libflac8 = FLAC stands for Free Lossless Audio Codec, an audio format similar to MP3, but lossless.
FILES_libflac8 = \
/usr/lib/libFLAC.so*

NAME_libflacpp6 = libflac++6
DESCRIPTION_libflacpp6 = FLAC stands for Free Lossless Audio Codec, an audio format similar to MP3, but lossless.
RDEPENDS_libflacpp6 = libgcc1 libogg0 libflac8 libstdc
FILES_libflacpp6 = \
/usr/lib/libFLAC++.so*

$(DEPDIR)/libflac.do_prepare: bootstrap $(DEPENDS_libflac)
	$(PREPARE_libflac)
	touch $@

$(DEPDIR)/libflac.do_compile: $(DEPDIR)/libflac.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libflac) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--disable-ogg \
		--disable-oggtest \
		--disable-id3libtest \
		--disable-asm-optimizations \
		--disable-doxygen-docs \
		--disable-xmms-plugin \
		--without-xmms-prefix \
		--without-xmms-exec-prefix \
		--without-libiconv-prefix \
		--without-id3lib
	touch $@

$(DEPDIR)/libflac: $(DEPDIR)/libflac.do_compile
	$(start_build)
	cd $(DIR_libflac) && \
		$(INSTALL_libflac)
	$(tocdk_build)
	$(toflash_build)
	touch $@


##############################   EXTERNAL_LCD   ################################


#
# graphlcd
#
BEGIN[[
graphlcd
  git
  {PN}-{PV}
  nothing:git://projects.vdr-developer.org/{PN}-base.git:r=1e01a8963f9ab95ba40ddb44a6c166b8e546053d:b=touchcol
  patch:file://{PN}.patch
  patch:file://{PN}_add_dynload_support.patch
  patch:file://{PN}_support_libusb1.0.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_graphlcd = "Driver and Tools for LCD4LINUX"
RDEPENDS_graphlcd = libusb-1.0
PKGR_graphlcd =r1
FILES_graphlcd = \
/usr/bin/* \
/usr/lib/libglcddrivers* \
/usr/lib/libglcdgraphics* \
/usr/lib/libglcdskin* \
/etc/graphlcd.conf

$(DEPDIR)/graphlcd.do_prepare: bootstrap libusb2 $(DEPENDS_graphlcd)
	$(PREPARE_graphlcd)
	touch $@

$(DEPDIR)/graphlcd.do_compile: $(DEPDIR)/graphlcd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_graphlcd) && \
	$(BUILDENV) \
		$(MAKE) all
	touch $@

$(DEPDIR)/graphlcd: $(DEPDIR)/graphlcd.do_compile
	$(start_build)
	install -d $(PKDIR)/etc
	cd $(DIR_graphlcd) && \
		$(INSTALL_graphlcd)
	$(tocdk_build)
	$(toflash_build)
	touch $@

##############################   LCD4LINUX   ###################################

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

#
# libusb2
#
BEGIN[[
libusb2
  1.0.9
  libusb-{PV}
  extract:http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-{PV}/libusb-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libusb2 = libusb-1.0
DESCRIPTION_libusb2 = Userspace library to access USB (version 1.0)
RDEPENDS_libusb2 = libc6
define postinst_libusb2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libusb2 = \
/usr/lib/libusb-1.0.so.*

$(DEPDIR)/libusb2.do_prepare: bootstrap $(DEPENDS_libusb2)
	$(PREPARE_libusb2)
	touch $@

$(DEPDIR)/libusb2.do_compile: $(DEPDIR)/libusb2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libusb2) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libusb2: $(DEPDIR)/libusb2.do_compile
	$(start_build)
	cd $(DIR_libusb2) && \
		$(INSTALL_libusb2)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libusb-compat
#
BEGIN[[
libusb_compat
  0.1.5
  libusb-compat-{PV}
  extract:http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-{PV}/libusb-compat-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libusb_compat = libusb-0.1
DESCRIPTION_libusb_compat = libusb-0.1 compatible layer for libusb1, a drop-in replacement that aims \
 to look, feel and behave exactly like libusb-0.1
RDEPENDS_libusb_compat = libusb-1.0 libc6
define postinst_libusb_compat
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libusb_compat = \
/usr/lib/libusb-0.1.so.*

$(DEPDIR)/libusb_compat.do_prepare: bootstrap libusb2 $(DEPENDS_libusb_compat)
	$(PREPARE_libusb_compat)
	touch $@

$(DEPDIR)/libusb_compat.do_compile: $(DEPDIR)/libusb_compat.do_prepare
	cd $(DIR_libusb_compat) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libusb_compat: $(DEPDIR)/libusb_compat.do_compile
	$(start_build)
	cd $(DIR_libusb_compat) && \
		$(INSTALL_libusb_compat)
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
# libcap
#
BEGIN[[
libcap
  2.22
  {PN}-{PV}
  extract:http://mirror.linux.org.au/linux/libs/security/linux-privs/{PN}2/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END
PACKAGES_libcap = libcap2 \
		  libcap_bin

DESCRIPTION_libcap2 = Library for getting/setting POSIX.1e capabilities
RDEPENDS_libcap2 = libc6
define postinst_libcap2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcap2 = /lib/*.so*

DESCRIPTION_libcap_bin = Library for getting/setting POSIX.1e capabilities
RDEPENDS_libcap_bin = libc6 libcap2
FILES_libcap_bin = /usr/sbin/*

$(DEPDIR)/libcap.do_prepare: bootstrap libattr $(DEPENDS_libcap)
	$(PREPARE_libcap)
	touch $@

$(DEPDIR)/libcap.do_compile: $(DEPDIR)/libcap.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libcap) && \
	$(MAKE) \
	DESTDIR=$(PKDIR)/ \
	PREFIX=$(PKDIR)/usr \
	LIBDIR=$(PKDIR)/lib \
	SBINDIR=$(PKDIR)/usr/sbin \
	INCDIR=$(PKDIR)/usr/include \
	BUILD_CC=gcc \
	PAM_CAP=no \
	LIBATTR=yes \
	RAISE_SETFCAP=no \
	CC=sh4-linux-gcc
	touch $@

$(DEPDIR)/libcap: $(DEPDIR)/libcap.do_compile
	$(start_build)
	cd $(DIR_libcap) && \
		$(INSTALL_libcap) \
		DESTDIR=$(PKDIR)/ \
		PREFIX=$(PKDIR)/usr \
		LIBDIR=$(PKDIR)/lib \
		SBINDIR=$(PKDIR)/usr/sbin \
		INCDIR=$(PKDIR)/usr/include \
		BUILD_CC=gcc \
		PAM_CAP=no \
		LIBATTR=yes \
		RAISE_SETFCAP=no \
		CC=sh4-linux-gcc
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# alsa-lib
#
BEGIN[[
libalsa
  1.0.26
  alsa-lib-{PV}
  extract:http://alsa.cybermirror.org/lib/alsa-lib-{PV}.tar.bz2
  #patch:file://alsa-lib-{PV}-soft_float.patch
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libalsa = "ALSA library"

FILES_libalsa = \
/usr/lib/libasound*

$(DEPDIR)/libalsa.do_prepare: bootstrap $(DEPENDS_libalsa)
	$(PREPARE_libalsa)
	touch $@

$(DEPDIR)/libalsa.do_compile: $(DEPDIR)/libalsa.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libalsa) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-debug=no \
		--enable-shared=no \
		--enable-static \
		--disable-python && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libalsa: $(DEPDIR)/libalsa.do_compile
	$(start_build)
	cd $(DIR_libalsa) && \
		$(INSTALL_libalsa)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# rtmpdump
#
BEGIN[[
rtmpdump
  git
  {PN}-{PV}
  git://git.ffmpeg.org/{PN}.git
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_rtmpdump = librtmp1
DESCRIPTION_rtmpdump = librtmp Real-Time Messaging Protocol API
RDEPENDS_rtmpdump = libssl1 libz1 libc6 libcrypto1
define postinst_rtmpdump
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_rtmpdump = /usr/lib/librtmp.*

$(DEPDIR)/rtmpdump.do_prepare: bootstrap openssl-dev openssl libz $(DEPENDS_rtmpdump)
	$(PREPARE_rtmpdump)
	touch $@

$(DEPDIR)/rtmpdump.do_compile: $(DEPDIR)/rtmpdump.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_rtmpdump) && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	$(BUILDENV) \
		make CROSS_COMPILE=$(target)-
	touch $@

$(DEPDIR)/rtmpdump: $(DEPDIR)/rtmpdump.do_compile
	$(start_build)
	cd $(DIR_rtmpdump) && \
		$(INSTALL_rtmpdump)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libdvbsi++
#
BEGIN[[
libdvbsipp
  0.3.7
  libdvbsi++-{PV}
  extract:http://www.saftware.de/libdvbsi++/libdvbsi++-{PV}.tar.bz2
  patch:file://libdvbsi++-{PV}.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END
PKGR_libdvbsipp = r0

NAME_libdvbsipp = libdvbsi++1
DESCRIPTION_libdvbsipp = libdvbsi++ is a open source C++ library for parsing DVB Service Information and MPEG-2 Program Specific Information.
RDEPENDS_libdvbsipp = libgcc1 libstdc++6
FILES_libdvbsipp = /usr/lib/libdvbsi++.so.*

$(DEPDIR)/libdvbsipp.do_prepare: bootstrap $(DEPENDS_libdvbsipp)
	$(PREPARE_libdvbsipp)
	touch $@

$(DEPDIR)/libdvbsipp.do_compile: $(DEPDIR)/libdvbsipp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdvbsipp) && \
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

$(DEPDIR)/libdvbsipp: $(DEPDIR)/libdvbsipp.do_compile
	$(start_build)
	cd $(DIR_libdvbsipp) && \
		$(INSTALL_libdvbsipp)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# tuxtxtlib
#
BEGIN[[
tuxtxtlib
  1.0
  libtuxtxt
  nothing:git://git.code.sf.net/p/openpli/tuxtxt.git:sub=libtuxtxt
  patch:file://libtuxtxt-{PV}-fix_dbox_headers.diff
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_tuxtxtlib = libtuxtxt0
DESCRIPTION_tuxtxtlib = tuxbox libtuxtxt
RDEPENDS_tuxtxtlib = libfreetype6 libz1
PKGR_tuxtxtlib = r1
FILES_tuxtxtlib = \
/usr/lib/libtuxtxt*

$(DEPDIR)/tuxtxtlib.do_prepare: bootstrap $(DEPENDS_tuxtxtlib)
	$(PREPARE_tuxtxtlib)
	touch $@

$(DEPDIR)/tuxtxtlib.do_compile: $(DEPDIR)/tuxtxtlib.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_tuxtxtlib) && \
	$(BUILDENV) \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	libtoolize --force && \
	automake --foreign --add-missing && \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/etc \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tuxtxtlib: $(DEPDIR)/tuxtxtlib.do_compile
	$(start_build)
	$(AUTOPKGV_tuxtxtlib)
	cd $(DIR_tuxtxtlib) && \
		$(INSTALL_tuxtxtlib)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# tuxtxt32bpp
#
BEGIN[[
tuxtxt32bpp
  1.0
  tuxtxt
  nothing:git://git.code.sf.net/p/openpli/tuxtxt.git:sub=tuxtxt
  patch:file://{PN}-{PV}-fix_dbox_headers.diff
  make:install:prefix=/usr:DESTDIR=PKDIR
# overwrite after make install
  install -m644 -D:file://../root/usr/tuxtxt/tuxtxt2.conf:PKDIR/etc/tuxtxt/tuxtxt2.conf
;
]]END

NAME_tuxtxt32bpp = libtuxtxt32bpp0
DESCRIPTION_tuxtxt32bpp = tuxbox tuxtxt for 32bit framebuffer
RDEPENDS_tuxtxt32bpp = libtuxtxt0 libfreetype6 libz1
PKGR_tuxtxt32bpp = r2
FILES_tuxtxt32bpp = \
/usr/lib/libtuxtxt32bpp* \
/usr/lib/enigma2/python/Plugins/Extensions/Tuxtxt/* \
/etc/tuxtxt/tuxtxt2.conf

$(DEPDIR)/tuxtxt32bpp.do_prepare: tuxtxtlib $(DEPENDS_tuxtxt32bpp)
	$(PREPARE_tuxtxt32bpp)
	touch $@

$(DEPDIR)/tuxtxt32bpp.do_compile: $(DEPDIR)/tuxtxt32bpp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_tuxtxt32bpp) && \
	$(BUILDENV) \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	libtoolize --force && \
	automake --foreign --add-missing && \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/etc \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tuxtxt32bpp: $(DEPDIR)/tuxtxt32bpp.do_compile
	$(start_build)
	$(AUTOPKGV_tuxtxt32bpp)
	cd $(DIR_tuxtxt32bpp) && \
		$(INSTALL_tuxtxt32bpp)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libdreamdvd2
#
BEGIN[[
libdreamdvd2
  git
  libdreamdvd
  nothing:git://github.com/mirakels/libdreamdvd.git:r=6aa22dd3f530ca4be49946e07e4a0bfe60427bdf
  patch:file://libdreamdvd-1.0-support_sh4.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_libdreamdvd2 = libdreamdvd0
DESCRIPTION_libdreamdvd2 = libdvdnav wrapper for enigma2 based stbs.
RDEPENDS_libdreamdvd2 = libdvdread4 libdvdnav4 libc6
define postinst_libdreamdvd2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
PKGR_libdreamdvd2 = r1
FILES_libdreamdvd2 = /usr/lib/*

$(DEPDIR)/libdreamdvd2.do_prepare: bootstrap libdvdread libdvdnav $(DEPENDS_libdreamdvd2)
	$(PREPARE_libdreamdvd2)
	touch $@

$(DEPDIR)/libdreamdvd2.do_compile: $(DEPDIR)/libdreamdvd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdreamdvd2) && \
	autoreconf -i && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdreamdvd2: $(DEPDIR)/libdreamdvd2.do_compile
	$(start_build)
	cd $(DIR_libdreamdvd2) && \
		$(INSTALL_libdreamdvd2)
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
# libvorbis
#
BEGIN[[
libvorbis
  1.3.3
  {PN}-{PV}
  extract:http://downloads.xiph.org/releases/vorbis/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libvorbis = "The libvorbis reference implementation provides both a standard encoder and decoder"
RDEPENDS_libvorbis = libogg0 libc6
define postinst_libvorbis
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libvorbis = /usr/lib/libvorbis*

$(DEPDIR)/libvorbis.do_prepare: bootstrap $(DEPENDS_libvorbis)
	$(PREPARE_libvorbis)
	touch $@

$(DEPDIR)/libvorbis.do_compile: $(DEPDIR)/libvorbis.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libvorbis) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libvorbis: $(DEPDIR)/libvorbis.do_compile
	$(start_build)
	cd $(DIR_libvorbis) && \
		$(INSTALL_libvorbis)
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
# libcdio
#
BEGIN[[
libcdio
  0.83
  {PN}-{PV}
  extract:ftp://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

PACKAGES_libcdio = libcdio_cdda0 \
		   libcdioxx0 \
		   libcdio_paranoia0 \
		   libcdio_utils \
		   libcdio12

DESCRIPTION_libcdio_cdda0 = gstreamer cdio-cdda library
RDEPENDS_libcdio_cdda0 = libcdio12 libc6
define postinst_libcdio_cdda0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdio_cdda0 = /usr/lib/libcdio_cdda.so.*

NAME_libcdioxx0 = libcdio++0
DESCRIPTION_libcdioxx0 =gstreamer cdio++ library
RDEPENDS_libcdioxx0 = libcdio12 libc6 libgcc1 libstdc++6
define postinst_libcdioxx0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdioxx0 = /usr/lib/libcdio++.so.*

DESCRIPTION_libcdio_paranoia0 = gstreamer cdio-paranoia library
RDEPENDS_libcdio_paranoia0 = libcdio12 libc6 libcdio_cdda0
define postinst_libcdio_paranoia0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdio_paranoia0 = /usr/lib/libcdio_paranoia.so.*

DESCRIPTION_libcdio_utils = libcdio version
RDEPENDS_libcdio_utils = libcdio12 libc6 libcdio_cdda0 libcdio_paranoia0 libncurses5
FILES_libcdio_utils = /usr/bin/*

DESCRIPTION_libcdio12 = gstreamer cdio-cdda library
RDEPENDS_libcdio12 = libc6
define postinst_libcdio12
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdio12 = /usr/lib/libcdio.so.*

$(DEPDIR)/libcdio.do_prepare: bootstrap $(DEPENDS_libcdio)
	$(PREPARE_libcdio)
	touch $@

$(DEPDIR)/libcdio.do_compile: $(DEPDIR)/libcdio.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libcdio) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libcdio: $(DEPDIR)/libcdio.do_compile
	$(start_build)
	cd $(DIR_libcdio) && \
		$(INSTALL_libcdio)
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
# mysql
#
BEGIN[[
mysql
  5.1.40
  {PN}-{PV}
  extract:http://downloads.{PN}.com/archives/{PN}-5.1/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_mysql = "MySQL"

FILES_mysql = \
/usr/bin/*

$(DEPDIR)/mysql.do_prepare: bootstrap $(DEPENDS_mysql)
	$(PREPARE_mysql)
	touch $@

$(DEPDIR)/mysql.do_compile: $(DEPDIR)/mysql.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_mysql) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--with-atomic-ops=up --with-embedded-server --prefix=/usr --sysconfdir=/etc/mysql --localstatedir=/var/mysql --disable-dependency-tracking --without-raid --without-debug --with-low-memory --without-query-cache --without-man --without-docs --without-innodb && \
	$(MAKE) all
	touch $@

$(DEPDIR)/mysql: $(DEPDIR)/mysql.do_compile
	$(start_build)
	cd $(DIR_mysql) && \
		$(INSTALL_mysql)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# xupnpd
#
BEGIN[[
xupnpd
  svn
  {PN}-{PV}
  svn://tsdemuxer.googlecode.com/svn/trunk/xupnpd/src/
  patch-0:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END


DESCRIPTION_xupnpd = eXtensible UPnP agent
FILES_xupnpd = \
/

$(DEPDIR)/xupnpd.do_prepare: bootstrap $(DEPENDS_xupnpd)
	$(PREPARE_xupnpd)
	touch $@

$(DEPDIR)/xupnpd.do_compile: $(DEPDIR)/xupnpd.do_prepare
	cd $(DIR_xupnpd) && \
	    $(BUILDENV) \
	$(MAKE) embedded
	touch $@

$(DEPDIR)/xupnpd: $(DEPDIR)/xupnpd.do_compile
	$(start_build)
	cd $(DIR_xupnpd)  && \
	  install -d 0644  $(PKDIR)/{etc,usr/bin}; \
	  install -m 0755 xupnpd- $(PKDIR)/usr/bin/xupnpd; \
	  install -d 0644  $(PKDIR)/usr/share/xupnpd/{ui,www,plugins,config,playlists}; \
	  install -m 0644 *.lua $(PKDIR)/usr/share/xupnpd; \
	  install -m 0644 ui/* $(PKDIR)/usr/share/xupnpd/ui; \
	  install -m 0644 www/* $(PKDIR)/usr/share/xupnpd/www; \
	  install -m 0644 plugins/* $(PKDIR)/usr/share/xupnpd/plugins; \
	  cp -a playlists/*.m3u $(PKDIR)/usr/share/xupnpd/playlists; \
	  $(LN_SF)  /usr/share/xupnpd/xupnpd.lua $(PKDIR)/etc/xupnpd.lua
#	  install -D -m 0755 xupnpd-init.file $(PKDIR)/etc/init.d/xupnpd

	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libmicrohttpd
#
BEGIN[[
libmicrohttpd
  0.9.19
  {PN}-{PV}
  extract:http://ftp.halifax.rwth-aachen.de/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmicrohttpd = ""

FILES_libmicrohttpd = \
/usr/lib/libmicrohttpd.*

$(DEPDIR)/libmicrohttpd.do_prepare: bootstrap $(DEPENDS_libmicrohttpd)
	$(PREPARE_libmicrohttpd)
	touch $@

$(DEPDIR)/libmicrohttpd.do_compile: $(DEPDIR)/libmicrohttpd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmicrohttpd) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmicrohttpd: $(DEPDIR)/libmicrohttpd.do_compile
	$(start_build)
	cd $(DIR_libmicrohttpd) && \
		$(INSTALL_libmicrohttpd)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libexif
#
BEGIN[[
libexif
  0.6.20
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_libexif = libexif12
DESCRIPTION_libexif = "libexif is a library for parsing, editing, and saving EXIF data."
RDEPENDS_libexif = libc6
FILES_libexif = /usr/lib/libexif.*

$(DEPDIR)/libexif.do_prepare: bootstrap $(DEPENDS_libexif)
	$(PREPARE_libexif)
	touch $@

$(DEPDIR)/libexif.do_compile: $(DEPDIR)/libexif.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libexif) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/libexif: $(DEPDIR)/libexif.do_compile
	$(start_build)
	cd $(DIR_libexif) && \
		$(INSTALL_libexif)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# minidlna
#
BEGIN[[
minidlna
  1.0.25
  {PN}-{PV}
  extract:http://netcologne.dl.sourceforge.net/project/{PN}/{PN}/{PV}/{PN}_{PV}_src.tar.gz
  patch:file://{PN}-{PV}.patch
  nothing:file://../root/etc/init.d/minidlna-init
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_minidlna = "The MiniDLNA daemon is an UPnP-A/V and DLNA service which serves multimedia content to compatible clients on the network."
RDEPENDS_minidlna = libexif12 libid3tag libflac8 libogg0 libjpeg8 libvorbis
define conffiles_minidlna
/etc/minidlna.conf
endef
define postinst_minidlna
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ minidlna start 98 S .
fi
endef

define postrm_minidlna
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ minidlna remove
fi
endef

define preinst_minidlna
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/minidlna" ]; then
	/etc/init.d/minidlna stop
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-f -r $$D"
	else
		OPT="-f"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ minidlna remove
fi
endef

define prerm_minidlna
#!/bin/sh
if [ -z "$ $$D" ]; then
	/etc/init.d/minidlna stop
fi
endef
FILES_minidlna = /usr/lib/* \
		 /usr/sbin/* \
		 /etc/init.d/minidlna \
		 /etc/minidlna.conf

$(DEPDIR)/minidlna.do_prepare: bootstrap libflac libogg libid3tag libvorbis libexif libjpeg $(DEPENDS_minidlna)
	$(PREPARE_minidlna)
	touch $@

$(DEPDIR)/minidlna.do_compile: $(DEPDIR)/minidlna.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_minidlna) && \
	libtoolize -f -c && \
	$(BUILDENV) \
	DESTDIR=$(targetprefix) \
	$(MAKE) \
	PREFIX=$(targetprefix)/usr \
	LIBDIR=$(targetprefix)/usr/lib \
	SBINDIR=$(targetprefix)/usr/sbin \
	INCDIR=$(targetprefix)/usr/include \
	PAM_CAP=no \
	LIBATTR=no
	touch $@

$(DEPDIR)/minidlna: $(DEPDIR)/minidlna.do_compile
	$(start_build)
	cd $(DIR_minidlna) && \
		$(INSTALL_minidlna)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
	$(INSTALL_FILE) $(DIR_minidlna)/minidlna.conf $(PKDIR)/etc/ && \
	$(INSTALL_BIN) $(DIR_minidlna)/minidlna-init $(PKDIR)/etc/init.d/minidlna && \
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# vlc
#
BEGIN[[
vlc
  1.1.13
  {PN}-{PV}
  extract:http://download.videolan.org/pub/videolan/{PN}/{PV}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_vlc = "VLC player"

FILES_vlc = \
/usr/bin/* \
/usr/lib/libvlc* \
/usr/lib/vlc/plugins/access/*.so \
/usr/lib/vlc/plugins/access_output/*.so \
/usr/lib/vlc/plugins/audio_filter/*.so \
/usr/lib/vlc/plugins/audio_mixer/*.so \
/usr/lib/vlc/plugins/audio_output/*.so \
/usr/lib/vlc/plugins/codec/*.so \
/usr/lib/vlc/plugins/control/*.so \
/usr/lib/vlc/plugins/demux/*.so \
/usr/lib/vlc/plugins/gui/*.so \
/usr/lib/vlc/plugins/meta_engine/*.so \
/usr/lib/vlc/plugins/misc/*.so \
/usr/lib/vlc/plugins/mux/*.so \
/usr/lib/vlc/plugins/packetizer/*.so \
/usr/lib/vlc/plugins/services_discovery/*.so \
/usr/lib/vlc/plugins/stream_filter/*.so \
/usr/lib/vlc/plugins/stream_out/*.so \
/usr/lib/vlc/plugins/video_chroma/*.so \
/usr/lib/vlc/plugins/video_filter/*.so \
/usr/lib/vlc/plugins/video_output/*.so \
/usr/lib/vlc/plugins/visualization/*.so

$(DEPDIR)/vlc.do_prepare: bootstrap libstdc++-dev libfribidi ffmpeg $(DEPENDS_vlc)
	$(PREPARE_vlc)
	touch $@

$(DEPDIR)/vlc.do_compile: $(DEPDIR)/vlc.do_prepare
	cd $(DIR_vlc) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--prefix=/usr \
		--disable-xcb \
		--disable-glx \
		--disable-qt4 \
		--disable-mad \
		--disable-postproc \
		--disable-a52 \
		--disable-qt4 \
		--disable-skins2 \
		--disable-remoteosd \
		--disable-lua \
		--disable-libgcrypt \
		--disable-nls \
		--disable-mozilla \
		--disable-dbus \
		--disable-sdl \
		--enable-run-as-root
	touch $@

$(DEPDIR)/vlc: $(DEPDIR)/vlc.do_compile
	$(start_build)
	cd $(DIR_vlc) && \
		$(INSTALL_vlc)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# djmount
#
BEGIN[[
djmount
  0.71
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/{PV}/{PN}-{PV}.tar.gz
  nothing:file://../root/etc/init.d/djmount-init
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_djmount =  mount UPnP server content as a linux filesystem
RDEPENDS_djmount = libfuse2 libc6 libupnp3
define postinst_djmount
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ djmount start 97 S .
fi
endef

define postrm_djmount
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ djmount remove
fi
endef

define preinst_djmount
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/djmount" ]; then
	/etc/init.d/djmount stop
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-f -r $$D"
	else
		OPT="-f"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ djmount remove
fi
endef

define prerm_djmount
#!/bin/sh
if [ -z "$ $$D" ]; then
	/etc/init.d/djmount stop
fi
endef
FILES_djmount = /usr/bin/* /etc/init.d/djmount

$(DEPDIR)/djmount.do_prepare: bootstrap fuse curl $(DEPENDS_djmount)
	$(PREPARE_djmount)
	touch $@

$(DEPDIR)/djmount.do_compile: $(DEPDIR)/djmount.do_prepare
	cd $(DIR_djmount) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/djmount: $(DEPDIR)/djmount.do_compile
	$(start_build)
	cd $(DIR_djmount) && \
		$(INSTALL_djmount)
	$(tocdk_build)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
	$(INSTALL_BIN) $(DIR_djmount)/djmount-init $(PKDIR)/etc/init.d/djmount && \
	$(toflash_build)
	touch $@

#
# libupnp
#
BEGIN[[
libupnp
  1.6.19
  {PN}-{PV}
  extract:http://sourceforge.net/projects/pupnp/files/latest/download/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

NAME_libupnp = libupnp3
DESCRIPTION_libupnp = The portable SDK for UPnP* Devices (libupnp) provides developers with an \
 API and open source code for building control points, devices, and \
 bridges that are compliant with Version 1.0 of the Universal Plug and \
 Play Device Architecture Specification.
RDEPENDS_libupnp = libc6
define postinst_libupnp
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libupnp = \
/usr/lib/*.so*

$(DEPDIR)/libupnp.do_prepare: bootstrap $(DEPENDS_libupnp)
	$(PREPARE_libupnp)
	touch $@

$(DEPDIR)/libupnp.do_compile: $(DEPDIR)/libupnp.do_prepare
	cd $(DIR_libupnp) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libupnp: $(DEPDIR)/libupnp.do_compile
	$(start_build)
	cd $(DIR_libupnp) && \
		$(INSTALL_libupnp)
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
# mediatomb
#
BEGIN[[
mediatomb
  0.12.1
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}_metadata.patch
#  patch:file://{PN}_libav_support.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_mediatomb = MediaTomb is an open source (GPL) UPnP MediaServer with a nice web user interfaces
FILES_mediatomb = \
/usr/bin/* \
/usr/share/mediatomb/*

$(DEPDIR)/mediatomb.do_prepare: bootstrap libstdc++-dev ffmpeg curl sqlite expat $(DEPENDS_mediatomb)
	$(PREPARE_mediatomb)
	touch $@

$(DEPDIR)/mediatomb.do_compile: $(DEPDIR)/mediatomb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_mediatomb) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-ffmpegthumbnailer \
		--disable-libmagic \
		--disable-mysql \
		--disable-id3lib \
		--disable-taglib \
		--disable-lastfmlib \
		--disable-libexif \
		--disable-libmp4v2 \
		--disable-inotify \
		--with-avformat-h=$(targetprefix)/usr/include \
		--disable-rpl-malloc \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/mediatomb: $(DEPDIR)/mediatomb.do_compile
	$(start_build)
	cd $(DIR_mediatomb) && \
		$(INSTALL_mediatomb)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# tinyxml
#
BEGIN[[
tinyxml
  2.6.2
  {PN}-{PV}
  extract:http://ignum.dl.sourceforge.net/project/tinyxml/tinyxml/{PV}/tinyxml_2_6_2.tar.gz
  pmove:{PN}:{PN}-{PV}
  patch:file://{PN}{PV}.patch
  make:install:PREFIX=PKDIR/usr:LD=sh4-linux-ld
;
]]END

DESCRIPTION_tinyxml = tinyxml
FILES_tinyxml = \
/usr/lib/*

$(DEPDIR)/tinyxml.do_prepare: $(DEPENDS_tinyxml)
	$(PREPARE_tinyxml)
	touch $@

$(DEPDIR)/tinyxml.do_compile: $(DEPDIR)/tinyxml.do_prepare
	cd $(DIR_tinyxml) && \
	libtoolize -f -c && \
	$(BUILDENV) \
	$(MAKE)
	touch $@

$(DEPDIR)/tinyxml: $(DEPDIR)/tinyxml.do_compile
	$(start_build)
	cd $(DIR_tinyxml) && \
		$(INSTALL_tinyxml)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# libnfs
#
BEGIN[[
libnfs
  git
  {PN}
  git://github.com/sahlberg/libnfs.git:r=c0ebf57b212ffefe83e2a50358499f68e7289e93
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libnfs = nfs
PKGR_libnfs = r1
FILES_libnfs = \
/usr/lib/*

$(DEPDIR)/libnfs.do_prepare: bootstrap $(DEPENDS_libnfs)
	$(PREPARE_libnfs)
	touch $@

$(DEPDIR)/libnfs.do_compile: $(DEPDIR)/libnfs.do_prepare
	cd $(DIR_libnfs) && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libnfs: $(DEPDIR)/libnfs.do_compile
	$(start_build)
	cd $(DIR_libnfs) && \
		$(INSTALL_libnfs)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# taglib
#
BEGIN[[
taglib
  1.8
  {PN}-{PV}
  extract:https://github.com/downloads/{PN}/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_taglib = taglib
FILES_taglib = \
/usr/*

$(DEPDIR)/taglib.do_prepare: bootstrap $(DEPENDS_taglib)
	$(PREPARE_taglib)
	touch $@

$(DEPDIR)/taglib.do_compile: $(DEPDIR)/taglib.do_prepare
	cd $(DIR_taglib) && \
	$(BUILDENV) \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_RELEASE_TYPE=Release . && \
	$(MAKE) all
	touch $@

$(DEPDIR)/taglib: $(DEPDIR)/taglib.do_compile
	$(start_build)
	cd $(DIR_taglib) && \
		$(INSTALL_taglib)
	$(tocdk_build)
	$(toflash_build)
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
