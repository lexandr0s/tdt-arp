#
# AR-P buildsystem smart Makefile
#
package[[ target_libusb_compat

BDEPENDS_${P} = $(target_libusb)

PV_${P} = 0.1.5
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/project/libusb/${PN}-0.1/${PN}-${PV}/${PN}-${PV}.tar.bz2
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
			--target=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libusb-0.1
DESCRIPTION_${P} = libusb-0.1 compatible layer for libusb1, a drop-in replacement that aims \
 to look, feel and behave exactly like libusb-0.1
RDEPENDS_${P} = libusb-1.0 libc6
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_${P} = /usr/lib/libusb-0.1.so.*

call[[ ipkbox ]]

]]package
