#
# AR-P buildsystem smart Makefile
#
package[[ target_udev_rules

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.3
PR_${P} = 1

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/udev/rules.d
  install_file:$(PKDIR)/etc/udev/rules.d/:file://60-dvb-ca.rules
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	touch $@

DESCRIPTION_${P} = custom udev rules
RDEPENDS_${P} = udev

call[[ ipkbox ]]

]]package