#
# AR-P buildsystem smart Makefile
#
package[[ target_netbase

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 4.34
PR_ST_${P} = 10
PR_${P} = ${PR_ST}-2

DESCRIPTION_${P} = Miscellaneous files for the base networking

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  dirextract:local://$(archivedir)/$(STLINUX)-$(${P})-${PV}-${PR_ST}.src.rpm
  extract:localwork://${DIR}/${PN}_${PV}.tar.gz

  install:-d:$(PKDIR)/etc/network
  install:-d:$(PKDIR)/etc/network/if-down.d
  install:-d:$(PKDIR)/etc/network/if-post-up.d
  install:-d:$(PKDIR)/etc/network/if-post-down.d
  install:-d:$(PKDIR)/etc/network/if-pre-up.d
  install:-d:$(PKDIR)/etc/network/if-pre-down.d
  install:-d:$(PKDIR)/etc/network/if-up.d

  install_file:$(PKDIR)/etc/protocols:localwork://${DIR}/etc-protocols
  install_file:$(PKDIR)/etc/services:localwork://${DIR}/etc-services
  install_file:$(PKDIR)/etc/rpc:localwork://${DIR}/etc-rpc

  install_file:$(PKDIR)/etc/network/interfaces:file://interfaces
  install_file:$(PKDIR)/etc/resolv.conf:file://resolv.conf
  install_file:$(PKDIR)/etc/hosts:file://hosts

#FIXME: ???
  install_bin:-D:$(PKDIR)/etc/init.d/udphc:file://udhcpc
  install_bin:-D:$(PKDIR)/usr/share/udhcpc/default.script:file://udhcpc-default.script
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
