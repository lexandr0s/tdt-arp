#
# AR-P buildsystem smart Makefile
#
package[[ target_initscripts

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 2
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = init scripts and rules for system start

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/init.d
  install:-d:$(PKDIR)/etc/rc.d
  install_file:$(PKDIR)/etc:file://inittab
  install_bin:$(PKDIR)/etc/init.d:file://hostname
  install_bin:$(PKDIR)/etc/init.d:file://inetd
  install_bin:$(PKDIR)/etc/init.d/initmodules:file://initmodules_$(TARGET)
  install_bin:$(PKDIR)/etc/init.d/halt:file://halt_$(TARGET)
  install_bin:$(PKDIR)/etc/init.d:file://mountall
  install_bin:$(PKDIR)/etc/init.d:file://mountsysfs
  install_bin:$(PKDIR)/etc/init.d:file://networking
  install_bin:$(PKDIR)/etc/init.d:file://rc
  install_bin:$(PKDIR)/etc/init.d:file://reboot
  install_bin:$(PKDIR)/etc/init.d:file://sendsigs
  install_bin:$(PKDIR)/etc/init.d:file://telnetd
  install_bin:$(PKDIR)/etc/init.d:file://syslogd
  install_bin:$(PKDIR)/etc/init.d:file://umountfs
  install_bin:$(PKDIR)/etc/init.d:file://lircd
# FIXME avahi mess
  install_bin:$(PKDIR)/etc/init.d:file://avahi-daemon
  install_bin:$(PKDIR)/etc/init.d:file://rdate
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})

	ln -sf ../init.d $(PKDIR)/etc/rc.d/init.d

	touch $@

define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ halt start 90 0 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ hostname start 40 S 0 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ inetd start 43 2 3 4 5 . stop 20 0 1 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ initmodules start 9 S .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ mountall start 35 S .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ mountsysfs start 02 S .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ networking start 40 S . stop 40 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ reboot start 90 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ sendsigs start 20 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ syslogd start 03 S .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ telnetd start 43 S . stop 30 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ lircd start 36 S . stop 80 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ umountfs start 40 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ avahi-daemon stop 20 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ rdate start 99 S .
endef

define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ halt remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ hostname remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ inetd remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ initmodules remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ mountall remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ mountsysfs remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ networking remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ reboot remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ sendsigs remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ syslogd remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ telnetd remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ lircd remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ umountfs remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ avahi-daemon remove
update-rc.d -r $$OPKG_OFFLINE_ROOT/ rdate remove
endef

call[[ ipkbox ]]

]]package
