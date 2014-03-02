#
# busybox
#

BEGIN[[
busybox
  1.22.1
  {PN}-{PV}
  extract:http://www.{PN}.net/downloads/{PN}-{PV}.tar.bz2
  nothing:file://{PN}-{PV}.config
  nothing:file://../root/etc/init.d/busybox-cron
  pmove:{PN}-{PV}/{PN}-{PV}.config:{PN}-{PV}/.config
  patch:file://{PN}-{PV}-ash.patch
  patch:file://{PN}-{PV}-date.patch
  patch:file://{PN}-{PV}-iplink.patch
  make:install:CONFIG_PREFIX=PKDIR
;
]]END

PACKAGES_busybox = busybox_cron \
		   busybox

DESCRIPTION_busybox_cron = Tiny versions of many common UNIX utilities in a single small executable.
FILES_busybox_cron = /etc/cron/crontabs \
		     /etc/init.d/busybox-cron
define postinst_busybox_cron
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ busybox-cron start 03 S . stop 99 0 6 .
fi
endef

define postrm_busybox_cron
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT=""
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ busybox-cron remove
fi
endef

define preinst_busybox_cron
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/busybox-cron" ]; then
	/etc/init.d/busybox-cron stop
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-f -r $$D"
	else
		OPT="-f"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ busybox-cron remove
fi
endef

define prerm_busybox_cron
#!/bin/sh
if [ -z "$$D" ]; then
	/etc/init.d/busybox-cron stop
fi
endef

PKGR_busybox = r0
DESCRIPTION_busybox = Tiny versions of many common UNIX utilities in a single small executable.

$(DEPDIR)/busybox.do_prepare: bootstrap $(DEPENDS_busybox)
	$(PREPARE_busybox)
	touch $@

$(DEPDIR)/busybox.do_compile: $(DEPDIR)/busybox.do_prepare
	cd $(DIR_busybox) && \
		$(MAKE) all \
			CROSS_COMPILE=$(target)- \
			CFLAGS_EXTRA="$(TARGET_CFLAGS)"
	touch $@

$(DEPDIR)/busybox: $(DEPDIR)/busybox.do_compile
	$(start_build)
	cd $(DIR_busybox) && \
		export CROSS_COMPILE=$(target)- && \
		$(INSTALL_busybox)
	install -m644 -D /dev/null $(PKDIR)/etc/shells
	export HHL_CROSS_TARGET_DIR=$(PKDIR) && $(hostprefix)/bin/target-shellconfig --add /bin/ash 5 && \
	$(INSTALL_DIR) $(PKDIR)/etc/init.d/ && \
	$(INSTALL_BIN) $(DIR_busybox)/busybox-cron $(PKDIR)/etc/init.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/cron/crontabs/
	$(tocdk_build)
	$(toflash_build)
	touch $@


$(eval $(call guiconfig,busybox))
