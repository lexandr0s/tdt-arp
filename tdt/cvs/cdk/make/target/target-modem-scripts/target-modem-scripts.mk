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
  install_bin:$(PKDIR)/etc/ppp/:file://../root/etc/ppp/ip-*
  install_bin:$(PKDIR)/usr/bin/:file://../root/usr/bin/modem.sh
  install_bin:$(PKDIR)/usr/bin/:file://../root/usr/bin/modemctrl.sh
  install_file:$(PKDIR)/etc/:file://../root/etc/modem.conf
  install_file:$(PKDIR)/etc/:file://../root/etc/modem.list
  install_file:$(PKDIR)/etc/udev/rules.d/:file://../root/etc/55-modem.rules
  install_file:$(PKDIR)/etc/udev/rules.d/:file://../root/etc/30-modemswitcher.rules
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
