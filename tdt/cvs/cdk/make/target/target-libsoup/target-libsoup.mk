#
# AR-P buildsystem smart Makefile
#
package[[ target_libsoup

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.40.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://download.gnome.org/sources/${PN}/2.40/${PN}-${PV}.tar.xz
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
			--disable-more-warnings \
			--without-gnome \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = libsoup is an HTTP client/server library

RDEPENDS_${P} = libz1 libxml2 libffi6 libsqlite3 libc6 libglib
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
