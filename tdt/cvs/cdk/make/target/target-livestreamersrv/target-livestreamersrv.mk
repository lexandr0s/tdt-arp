#
# AR-P buildsystem smart Makefile
#
package[[ target_livestreamersrv

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = git
PR_${P} = 1

DIR_${P} = $(WORK_${P})/livestreamersrv-${PV}

call[[ base ]]

rule[[
  git://github.com/athoik/livestreamersrv.git
  install:-d:$(PKDIR)/usr/sbin
  install:-d:$(PKDIR)/etc/init.d
  install:-d:$(PKDIR)/etc/rc.d/rc3.d
  install:-d:$(PKDIR)/etc/rc.d/rc6.d
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
	ln -sf /etc/init.d/livestreamersrv $(PKDIR)/etc/rc.d/rc3.d/S50livestreamersrv
	ln -sf /etc/init.d/livestreamersrv $(PKDIR)/etc/rc.d/rc6.d/K50livestreamersrv
	touch $@

call[[ ipk ]]


DESCRIPTION_${P} = Livestreamersrv is a helper deamon for livestreamer.
RDEPENDS_${P} = python_core livestreamer

call[[ ipkbox ]]

]]package
