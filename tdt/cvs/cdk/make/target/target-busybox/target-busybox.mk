#
# AR-P buildsystem smart Makefile
#
package[[ target_busybox

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_libffi)

PV_${P} = git
PR_${P} = 1

DESCRIPTION_${P} = Tiny versions of many common UNIX utilities in a single small executable.

call[[ base ]]

rule[[
  git://git.busybox.net/${PN}.git
  nothing:file://${PN}.config
  nothing:file://busybox-cron
  nothing:file://syslog.busybox
  nothing:file://autologin
  pmove:${DIR}/${PN}.config:${DIR}/.config
]]rule

call[[ git ]]

MAKE_FLAGS_${P} = \
	CROSS_COMPILE=$(target)- \
	CFLAGS_EXTRA="$(TARGET_CFLAGS)"


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		make $(MAKE_FLAGS_${P}) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		make $(MAKE_FLAGS_${P}) install CONFIG_PREFIX=$(PKDIR)

#	install -m644 -D /dev/null $(PKDIR)/etc/shells
#	export HHL_CROSS_TARGET_DIR=$(PKDIR) && $(hostprefix)/bin/target-shellconfig --add /bin/ash 5

	install -d $(PKDIR)/etc/init.d/
	install -m755 $(DIR_${P})/busybox-cron $(PKDIR)/etc/init.d
	install -d $(PKDIR)/etc/cron/crontabs/
	install -m755 $(DIR_${P})/syslog.busybox $(PKDIR)/etc/init.d
# FIXME:
	install -d $(PKDIR)/bin
	install -m755 $(DIR_${P})/autologin $(PKDIR)/bin/autologin

	touch $@

call[[ TARGET_base_do_config ]]

PACKAGES_${P} = busybox_cron busybox_syslog busybox

FILES_busybox = /

FILES_busybox_cron = \
	/etc/cron/crontabs \
	/etc/init.d/busybox-cron

FILES_busybox_syslog = \
	/etc/init.d/syslog.busybox

define postinst_busybox_cron
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ busybox-cron start 03 S . stop 99 0 6 .

endef
define postrm_busybox_cron
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ busybox-cron remove
endef

define preinst_busybox_cron
#!/bin/sh
if [ -z "$$OPKG_OFFLINE_ROOT" -a -f "/etc/init.d/busybox-cron" ]; then
	/etc/init.d/busybox-cron stop
fi
update-rc.d -r $$OPKG_OFFLINE_ROOT/ busybox-cron remove
endef
define prerm_busybox_cron
#!/bin/sh
$$OPKG_OFFLINE_ROOT/etc/init.d/busybox-cron stop
endef

define postinst_busybox_syslog
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ syslog.busybox start 36 S .

endef
define postrm_busybox_syslog
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ syslog.busybox remove
endef

define preinst_busybox_syslog
#!/bin/sh
if [ -z "$$OPKG_OFFLINE_ROOT" -a -f "/etc/init.d/syslog.busybox" ]; then
	/etc/init.d/syslog.busybox stop
fi
update-rc.d -r $$OPKG_OFFLINE_ROOT/ syslog.busybox remove
endef
define prerm_busybox_syslog
#!/bin/sh
$$OPKG_OFFLINE_ROOT/etc/init.d/syslog.busybox stop
endef

call[[ ipkbox ]]

]]package
