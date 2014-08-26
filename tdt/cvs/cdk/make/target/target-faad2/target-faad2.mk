#
# AR-P buildsystem smart Makefile
#
package[[ target_faad2

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.7
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/faac/faad2-src/${PN}-${PV}/${PN}-${PV}.tar.bz2
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

DESCRIPTION_${P} = libmms version 0.6.2-r0  MMS stream protocol library
PACKAGES_${P} = faad2 libfaad2
RDEPENDS_faad2 = libc6 libfaad2
FILES_faad2 = /usr/bin/*

RDEPENDS_libfaad2 = libc6
define postinst_libfaad2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libfaad2 = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
