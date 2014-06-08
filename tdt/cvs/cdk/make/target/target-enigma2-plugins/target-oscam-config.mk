#
# AR-P buildsystem smart Makefile
#
#
# enigma2-plugin-cams-oscam-config
#

package[[ target_oscam_config

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/var/keys
  install_file:$(PKDIR)/var/keys:file://oscam.conf
  install_file:$(PKDIR)/var/keys:file://oscam.dvbapi
  install_file:$(PKDIR)/var/keys:file://oscam.services
  install_file:$(PKDIR)/var/keys:file://oscam.srvid
  install_file:$(PKDIR)/var/keys:file://oscam.user
  install_file:$(PKDIR)/var/keys:file://oscam.guess
ifdef CONFIG_SPARK7162
  install_file:$(PKDIR)/var/keys/oscam.server:file://oscam.server2
else
  install_file:$(PKDIR)/var/keys:file://oscam.server
endif
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})

	touch $@

NAME_${P} = enigma2-plugin-cams-oscam-config
DESCRIPTION_${P} = Example configs for Open Source Conditional Access Module software
RDEPENDS_${P} = enigma2-plugin-cams-oscam
FILES_${P} = /var/keys/oscam.*

define conffiles_${P}
/var/keys/oscam.conf
/var/keys/oscam.dvbapi
/var/keys/oscam.services
/var/keys/oscam.srvid
/var/keys/oscam.user
/var/keys/oscam.server
/var/keys/oscam.guess
endef

call[[ ipkbox ]]

]]package
