#
# AR-P buildsystem smart Makefile
#
package[[ target_libmms

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.6.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${PN}-${PV}.tar.gz
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

NAME_${P} = libmms0
DESCRIPTION_${P} = libmms version 0.6.2-r0  MMS stream protocol library
RDEPENDS_${P} = libc6 libglib
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
