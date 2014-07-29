#
# AR-P buildsystem smart Makefile
#
package[[ target_libmpeg2

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.5.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://${PN}.sourceforge.net/files/${PN}-${PV}.tar.gz
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
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  Library and test program for decoding MPEG-2 and MPEG-1 video streams
PACKAGES_${P} = libmpeg2 libmpeg2convert0 mpeg2dec

RDEPENDS_libmpeg2 = libc6
define postinst_libmpeg2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libmpeg2 = /usr/lib/libmpeg2.so.*

RDEPENDS_libmpeg2convert0 = libc6
define postinst_libmpeg2convert0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libmpeg2convert0 = /usr/lib/libmpeg2convert.so.*

RDEPENDS_mpeg2dec = libmpeg2 libmpeg2convert0 libc6
FILES_mpeg2dec = /usr/bin/*

call[[ ipkbox ]]

]]package
