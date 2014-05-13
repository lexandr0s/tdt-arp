#
# AR-P buildsystem smart Makefile
#
package[[ target_modem_scripts

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.4
PR_${P} = 1

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/udev/rules.d
  install:-d:$(PKDIR)/etc/ppp/peers
  install:-d:$(PKDIR)/usr/bin
  install_bin:$(PKDIR)/etc/ppp/:file://ip-*
  install_bin:$(PKDIR)/usr/bin/:file://modem.sh
  install_bin:$(PKDIR)/usr/bin/:file://modemctrl.sh
  install_file:$(PKDIR)/etc/:file://modem.conf
  install_file:$(PKDIR)/etc/:file://modem.list
  install_file:$(PKDIR)/etc/udev/rules.d/:file://55-modem.rules
  install_file:$(PKDIR)/etc/udev/rules.d/:file://30-modemswitcher.rules
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	touch $@

DESCRIPTION_${P} = utils to setup 3G modems
RDEPENDS_${P} = pppd usb_modeswitch

call[[ ipkbox ]]

]]package
