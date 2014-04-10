#
# AR-P buildsystem smart Makefile
#
package[[ target_tuxbox_configs

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 1
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/tuxbox
  install_file:$(PKDIR)/etc/tuxbox:file://../root/etc/tuxbox/satellites.xml
  install_file:$(PKDIR)/etc/tuxbox:file://../root/etc/tuxbox/cables.xml
  install_file:$(PKDIR)/etc/tuxbox:file://../root/etc/tuxbox/terrestrial.xml
  install_file:$(PKDIR)/etc/tuxbox:file://../root/etc/tuxbox/timezone.xml

]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)

	cd $(DIR_${P}) && $(INSTALL_${P})
	ln -sf /etc/tuxbox/timezone.xml $(PKDIR)/etc/timezone.xml

	touch $@

call[[ ipk ]]

PACKAGES_${P} = \
	config_satellites \
	config_cables \
	config_terrestrial \
	config_timezone

DESCRIPTION_config_cables = cables.xml config
FILES_config_cables = /etc/tuxbox/cables.xml

DESCRIPTION_config_terrestrial = terrestrial.xml config
FILES_config_terrestrial = /etc/tuxbox/terrestrial.xml

DESCRIPTION_config_satellites = satellites.xml config
FILES_config_satellites = /etc/tuxbox/satellites.xml

DESCRIPTION_config_timezone = timezone.xml config
FILES_config_timezone = /etc/tuxbox/timezone.xml /etc/timezone.xml

call[[ ipkbox ]]

]]package