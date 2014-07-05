#
# AR-P buildsystem smart Makefile
#
package[[ target_libupnp

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.6.19
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/pupnp/files/latest/download/${PN}-${PV}.tar.bz2
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
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = The portable SDK for UPnP* Devices (libupnp) provides developers with an \
 API and open source code for building control points, devices, and \
 bridges that are compliant with Version 1.0 of the Universal Plug and \
 Play Device Architecture Specification.
NAME_${P} = libupnp3
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so*
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
