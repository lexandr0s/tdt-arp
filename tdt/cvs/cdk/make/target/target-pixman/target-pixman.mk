#
# AR-P buildsystem smart Makefile
#
package[[ target_pixman

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.32.4
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://xorg.freedesktop.org/releases/individual/lib/${PN}-${PV}.tar.bz2
  patch:file://0001-ARM-qemu-related-workarounds-in-cpu-features-detecti.patch
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
			--disable-gtk \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Pixman provides a library for manipulating pixel regions -- a set of Y-X \
 banded rectangles, image compositing using the Porter/Duff model and \
 implicit mask generation for geometric primitives including trapezoids, \
 triangles, and rectangles.
NAME_${P} = libpixman

RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
