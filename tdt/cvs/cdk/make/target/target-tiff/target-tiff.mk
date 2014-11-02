#
# AR-P buildsystem smart Makefile
#
package[[ target_tiff

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 4.0.3
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.remotesensing.org/pub/lib${PN}/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libtiff5 \
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
FILES_libtiff5 = /usr/lib/libtiff.so.*

DESCRIPTION_libtiffxx5 =  Provides support for the Tag Image File Format (TIFF).
RDEPENDS_libtiffxx5 = libgcc1 libstdc++6 liblzma5 libtiff5 libz1 libjpeg8 libc6
define postinst_libtiffxx5
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libtiffxx5 = /usr/lib/libtiffxx.so.*

DESCRIPTION_libtiff_utils =  Provides support for the Tag Image File Format (TIFF).
RDEPENDS_libtiff_utils = libtiff5 libc6
FILES_libtiff_utils = /usr/bin/*

call[[ ipkbox ]]

]]package
