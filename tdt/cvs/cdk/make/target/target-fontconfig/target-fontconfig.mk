#
# FONTCONFIG
#
package[[ target_fontconfig

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_libxml2) $(target_freetype) $(target_expat)

PV_${P} = 2.11.1
PR_${P} = 1

DESCRIPTION_${P} = Generic font configuration library \
 Fontconfig is a font configuration and customization library, which does \
 not depend on the X Window System. It is designed to locate fonts within \
 the system and select them according to requirements specified by \
 applications. Fontconfig is not a rasterization library, nor does it \
 impose a particular rasterization library on the application. The \
 X-specific library 'Xft' uses fontconfig along with freetype to specify \
 and rasterize fonts.

call[[ base ]]

rule[[
  extract:http://${PN}.org/release/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os -I$(targetprefix)/usr/include/libxml2" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-arch=sh4 \
			--with-freetype-config=$(targetprefix)/usr/bin/freetype-config \
			--with-expat-includes=$(targetprefix)/usr/include \
			--with-expat-lib=$(targetprefix)/usr/lib \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-docs \
			--without-add-fonts \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libfontconfig1 fontconfig_utils

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

RDEPENDS_fontconfig_utils = libfreetype6 libc6 libfontconfig1
FILES_fontconfig_utils = /usr/bin/*

call[[ ipkbox ]]

]]package
