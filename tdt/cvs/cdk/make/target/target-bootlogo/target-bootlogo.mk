#
# AR-P buildsystem smart Makefile
#
package[[ target_bootlogo

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 1
PACKAGE_ARCH_${P} = all

DESCRIPTION_${P} = bootlogo.mvi

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/boot
  install_file:$(PKDIR)/boot/bootlogo.mvi:file://../root/bootscreen/bootlogo.mvi
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	touch $@

NAME_${P} = bootlogo
SRC_URI_${P} = unknown

call[[ ipkbox ]]

]]package
