#
# AR-P buildsystem smart Makefile
#
package[[ target_flash_tools

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 1

DESCRIPTION_${P} = Tools for changing internal flash

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc
  install:-d:$(PKDIR)/bin
  install:-d:$(PKDIR)/sbin
  install_file:$(PKDIR)/etc/fw_env.config:file://fw_env.config_spark
  install_bin:$(PKDIR)/bin/:file://fw_printenv
  install_bin:$(PKDIR)/bin/:file://fw_setenv
  install_bin:$(PKDIR)/bin/setspark.sh:file://setspark.sh
  install_bin:$(PKDIR)/sbin/:file://flash_*
  install_bin:$(PKDIR)/sbin/:file://nandwrite
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})

	touch $@

call[[ ipkbox ]]

]]package
