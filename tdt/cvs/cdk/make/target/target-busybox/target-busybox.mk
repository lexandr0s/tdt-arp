#
# AR-P buildsystem smart Makefile
#
package[[ target_busybox

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_libffi)

PV_${P} = 1.22.1
PR_${P} = 1

DESCRIPTION_${P} = Tiny versions of many common UNIX utilities in a single small executable.

call[[ base ]]

rule[[
  extract:http://www.${PN}.net/downloads/${PN}-${PV}.tar.bz2
  nothing:file://${PN}-${PV}.config
  nothing:file://busybox-cron
  nothing:file://autologin
  pmove:${DIR}/${PN}-${PV}.config:${DIR}/.config
  patch:file://${PN}-${PV}-ash.patch
  patch:file://${PN}-${PV}-date.patch
  patch:file://${PN}-${PV}-iplink.patch
]]rule

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
# FIXME:
	install -d $(PKDIR)/bin
	install -m755 $(DIR_${P})/autologin $(PKDIR)/bin/autologin

	touch $@

call[[ TARGET_base_do_config ]]

PACKAGES_${P} = busybox_cron busybox

FILES_busybox = /

FILES_busybox_cron = \
	/etc/cron/crontabs \
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

call[[ ipkbox ]]

]]package
