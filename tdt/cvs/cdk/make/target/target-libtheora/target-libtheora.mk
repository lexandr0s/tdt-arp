#
# AR-P buildsystem smart Makefile
#
package[[ target_libtheora

BDEPENDS_${P} = $(target_glibc) $(target_libogg)

PV_${P} = 1.1.1
PR_${P} = 1

DESCRIPTION_${P} = Theora Video Codec  The libtheora reference implementation provides the standard encoder and   decoder under a BSD license.

call[[ base ]]

rule[[
  extract:http://downloads.xiph.org/releases/theora/${PN}-${PV}.tar.gz
  patch:file://no-docs.patch
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
			--disable-examples \
			--prefix=/usr \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

RDEPENDS_${P} = libc6 libogg0
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.*


call[[ ipkbox ]]

]]package
