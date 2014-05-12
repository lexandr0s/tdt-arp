#
# AR-P buildsystem smart Makefile
#
package[[ target_flash_tools

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Miscellaneous files for the base system.

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc
  install:-d:$(PKDIR)/bin
  install:-d:$(PKDIR)/sbin
  install_file:$(PKDIR)/etc/fw_env.config:file://../root/etc/fw_env.config_spark
  install_bin:$(PKDIR)/bin/:file://../root/bin/fw_*
  install_bin:$(PKDIR)/bin/setspark.sh:file://../root/bin/setspark.sh
  install_bin:$(PKDIR)/sbin/:file://../root/sbin/flash_*
  install_bin:$(PKDIR)/sbin/:file://../root/sbin/nand*
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
