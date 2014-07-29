#
# AR-P buildsystem smart Makefile
#
package[[ target_libsoup

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.33.90
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://download.gnome.org/sources/${PN}/2.33/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
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
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
