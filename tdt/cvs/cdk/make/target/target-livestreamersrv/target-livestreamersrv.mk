#
# AR-P buildsystem smart Makefile
#
package[[ target_livestreamersrv

PV_${P} = git
PR_${P} = 2

DIR_${P} = $(WORK_${P})/livestreamersrv-${PV}

call[[ base ]]

rule[[
  git://github.com/athoik/livestreamersrv.git
  install:-d:$(PKDIR)/usr/sbin
  install:-d:$(PKDIR)/etc/init.d
  install:-d:$(PKDIR)/usr/share
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	$(INSTALL_BIN) ${DIR}/livestreamersrv $(PKDIR)/usr/sbin/livestreamersrv
	ln -sf /usr/sbin/livestreamersrv $(PKDIR)/etc/init.d/livestreamersrv
	$(INSTALL_FILE) $(DIR_${P})/offline.mp4 $(PKDIR)/usr/share/offline.mp4

	touch $@

call[[ ipk ]]


DESCRIPTION_${P} = Livestreamersrv is a helper deamon for livestreamer.
RDEPENDS_${P} = python_core livestreamer
define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ livestreamersrv start 50 3 . stop 50 6 .
/etc/init.d/livestreamersrv start
endef

define prerm_${P}
#!/bin/sh
/etc/init.d/livestreamersrv stop
update-rc.d -r $$OPKG_OFFLINE_ROOT/ -f livestreamersrv remove
endef

call[[ ipkbox ]]

]]package
