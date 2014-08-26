#
# AR-P buildsystem smart Makefile
#
package[[ target_cairo

BDEPENDS_${P} = $(target_libpng) $(target_pixman)

PV_${P} = 1.12.16
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://cairographics.org/releases/${PN}-${PV}.tar.xz
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
			--enable-tee \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Cairo is a multi-platform library providing anti-aliased vector-based rendering for multiple target backends.
PACKAGES_${P} = \
libcairo2 \
libcairo_gobject2 \
libcairo_perf_utils \
libcairo_script_interpreter2

RDEPENDS_libcairo2 = libpng16 libpixman libz1 libfreetype6 libc6 libexpat1 libfontconfig1
FILES_libcairo2 = /usr/lib/libcairo.so.*
define postinst_libcairo2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libcairo_gobject2 = libgcc1 libz1 libpng16 libpixman libffi6 libfreetype6 libcairo2 libc6 libglib
FILES_libcairo_gobject2 = /usr/lib/libcairo-gobject.so.*
define postinst_libcairo_gobject2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libcairo_perf_utils = libgcc1 libz1 libc6
FILES_libcairo_perf_utils = /usr/bin/cairo-trace  /usr/lib/cairo/libcairo-trace.so.*

RDEPENDS_libcairo_script_interpreter2 = libgcc1 libpng16 libpixman libz1 libfreetype6 libcairo2 libc6 libexpat1 libfontconfig1
FILES_libcairo_script_interpreter2 = /usr/lib/libcairo-script-interpreter.so.*
define postinst_libcairo_script_interpreter2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
