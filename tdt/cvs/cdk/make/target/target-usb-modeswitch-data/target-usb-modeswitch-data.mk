#
# AR-P buildsystem smart Makefile
#
package[[ target_usb_modeswitch_data

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 20140327
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.draisberghof.de/usb_modeswitch/${PN}-${PV}.tar.bz2
  patch:file://${PN}.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = usb-modeswitch-data
RDEPENDS_${P} = usb_modeswitch
FILES_${P} = /usr/share/*

call[[ ipkbox ]]

]]package
