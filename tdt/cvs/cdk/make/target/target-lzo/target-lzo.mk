#
# AR-P buildsystem smart Makefile
#
package[[ target_lzo

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.08
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.oberhumer.com/opensource/${PN}/download/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--enable-shared \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Lossless data compression library
NAME_{P} = liblzo2-2
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/liblzo2.so.*

define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
