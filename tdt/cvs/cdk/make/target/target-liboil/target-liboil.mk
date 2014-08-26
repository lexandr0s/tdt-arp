#
# AR-P buildsystem smart Makefile
#
package[[ target_liboil

BDEPENDS_${P} = $(target_glib2)

PV_${P} = 0.3.17
PR_${P} = 1

DESCRIPTION_${P} = Liboil is a library of simple functions that are optimized for various CPUs

call[[ base ]]

rule[[
  extract:http://liboil.freedesktop.org/download/${PN}-${PV}.tar.gz
  patch:file://no-tests.patch
  patch:file://fix-unaligned-whitelist.patch
  patch:file://0001-Fix-enable-vfp-flag.patch
  patch:file://liboil_fix_for_x32.patch
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
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.*


call[[ ipkbox ]]

]]package
