#
# AR-P buildsystem smart Makefile
#
package[[ target_update_rcd

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 2

call[[ base ]]

rule[[
  nothing:git://github.com/philb/update-rc.d
  patch:file://update-rc-add-verbose.patch
  patch:file://update-rc-check-if-symlinks-are-valid.patch
  patch:file://update-rc-use-cmdline.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PREPARE_${P})
	$(PKDIR_clean)

	$(INSTALL_DIR) $(PKDIR)/usr/sbin/
	$(INSTALL_BIN) ${DIR}/update-rc.d $(PKDIR)/usr/sbin/update-rc.d
# FIXME:
	$(INSTALL_BIN) ${DIR}/update-rc.d $(hostprefix)/bin/update-rc.d

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = update-rc.d is a utilities that allows the management of symlinks to the initscripts in the /etc/rcN.d directory structure.
NAME_${P} = update-rc.d
PACKAGE_ARCH_${P} = all
FILES_${P} = /usr/sbin/update-rc.d

call[[ ipkbox ]]

]]package
