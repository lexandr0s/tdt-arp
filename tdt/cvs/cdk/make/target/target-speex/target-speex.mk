#
# AR-P buildsystem smart Makefile
#
package[[ target_speex

BDEPENDS_${P} = $(target_libogg)

PV_${P} = 1.2rc1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.us.xiph.org/releases/speex/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-fixed-point \
			--with-ogg-libraries=$(targetprefix)/usr/lib \
			--disable-float-api \
			--disable-vbr \
			--with-ogg-includes=$(targetprefix)/usr/include \
			--disable-oggtest \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Speech Audio Codec  Speex is an Open Source/Free Software patent-free audio compression   format designed for speech.
PACKAGES_${P} = \
speex_bin \
speex

RDEPENDS_speex_bin = speex libogg0 libc6
FILES_speex_bin = /usr/bin/*

RDEPENDS_speex = libc6
FILES_speex = /usr/lib/*.so.*
define postinst_speex
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
