#
# AR-P buildsystem smart Makefile
#
package[[ target_firmware

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 2
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = firmware non public

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  nothing:file://component_7111_mb618.fw
  nothing:file://component_7105_pdk7105.fw
  nothing:file://dvb-fe-avl2108.fw
  nothing:file://dvb-fe-stv6306.fw
]]rule

$(TARGET_${P}).do_package: $(DEPENDS_${P})
	$(PREPARE_${P})
	$(PKDIR_clean)

	$(INSTALL_DIR) $(PKDIR)/lib/firmware/
ifdef CONFIG_SPARK
	$(INSTALL_FILE) ${DIR}/component_7111_mb618.fw $(PKDIR)/lib/firmware/component.fw
endif
ifdef CONFIG_SPARK7162
	$(INSTALL_FILE) ${DIR}/component_7105_pdk7105.fw $(PKDIR)/lib/firmware/component.fw
endif
ifdef CONFIG_HL101
	$(INSTALL_FILE) ${DIR}/dvb-fe-avl2108.fw $(PKDIR)/lib/firmware/
	$(INSTALL_FILE) ${DIR}/dvb-fe-stv6306.fw $(PKDIR)/lib/firmware/
endif

	touch $@

NAME_${P} = firmware
SRC_URI_${P} = stlinux.com
FILES_${P} = \
	/lib/firmware/component.fw \
	/etc/fstab

call[[ ipkbox ]]

]]package