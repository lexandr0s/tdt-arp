#
# AR-P buildsystem smart Makefile
#
package[[ target_compat_wireless

PV_${P} = 2012-12-06
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Drivers wireless for stm box
BDEPENDS_${P} = $(target_linux_kernel)
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.orbit-lab.org/kernel/compat-wireless/${PN}-${PV}.tar.bz2
  patch:file://${PN}.diff
  patch:file://002-disable_rfkill.patch
  patch:file://008-led_default.patch
]]rule

MAKE_FLAGS_${P} = \
	ARCH=sh \
	CROSS_COMPILE=$(target)- \
	DESTDIR=$(DIR_${P}) \
	KLIB=/lib/modules/$(KERNEL_VERSION) \
	KLIB_BUILD=$(targetprefix)/lib/modules/$(KERNEL_VERSION)/build



$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P}) && \
	cd $(DIR_${P}) && \
	./scripts/driver-select $(MAKE_FLAGS_${P})
	touch $@


$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	$(MAKE) $(MAKE_FLAGS_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(INSTALL_DIR) $(PKDIR)/lib/modules/$(KERNEL_VERSION)/updates/
	$(INSTALL_DIR) $(PKDIR)/lib/udev/
	$(INSTALL_DIR) $(PKDIR)/etc/udev/rules.d/
	$(INSTALL_FILE) $(DIR_${P})/udev/50-compat_firmware.rules $(PKDIR)/etc/udev/rules.d
	$(INSTALL_BIN) $(DIR_${P})/udev/compat_firmware.sh $(PKDIR)/lib/udev
	cd $(DIR_${P}) && \
	  for f in `find . -name *.ko`; do \
	    sh4-linux-strip --strip-debug $$f; \
	    mkdir -p $(PKDIR)/lib/modules/$(KERNEL_VERSION)/updates/`dirname $$f`; \
	    cp $$f $(PKDIR)/lib/modules/$(KERNEL_VERSION)/updates/`dirname $$f`; done
	touch $@

call[[ ipk ]]

RDEPENDS_${P} = linux-kernel

define postinst_${P}
#!/bin/sh
depmod -b $$OPKG_OFFLINE_ROOT/ -a $(KERNEL_VERSION)
endef

PACKAGES_${P} = \
	kernel_module_compat \
	kernel_module_ath \
	compat_rules \
	kernel_module_ath9k_htc \
	kernel_module_mac80211 \
	kernel_module_cfg80211 \
	kernel_module_carl9170 \
	kernel_module_rt73usb

DESCRIPTION_kernel_module_compat = Common compat modules
FILES_kernel_module_compat = /lib/modules/$(KERNEL_VERSION)/updates/compat

DESCRIPTION_kernel_module_ath = Common driver ath
FILES_kernel_module_ath = /lib/modules/$(KERNEL_VERSION)/updates/drivers/net/wireless/ath/ath.ko

DESCRIPTION_compat_rules = Udev rules for driver control
FILES_compat_rules = /lib/udev /etc

DESCRIPTION_kernel_module_ath9k_htc = Wifi driver for Atheros ath9k
RDEPENDS_kernel_module_ath9k_htc = kernel_module_compat kernel_module_ath compat_rules firmware_ath9k_htc kernel_module_mac80211 kernel_module_cfg80211
FILES_kernel_module_ath9k_htc = /lib/modules/$(KERNEL_VERSION)/updates/drivers/net/wireless/ath/ath9k

DESCRIPTION_kernel_module_mac80211 = Kernel module mac80211
FILES_kernel_module_mac80211 = /lib/modules/$(KERNEL_VERSION)/updates/net/mac80211

DESCRIPTION_kernel_module_cfg80211 = Kernel module cfg80211
FILES_kernel_module_cfg80211 = /lib/modules/$(KERNEL_VERSION)/updates/net/wireless

DESCRIPTION_kernel_module_carl9170 = Kernel module carl9170
RDEPENDS_kernel_module_carl9170 = kernel_module_compat kernel_module_ath compat_rules firmware_carl9170 kernel_module_mac80211 kernel_module_cfg80211
FILES_kernel_module_carl9170 = /lib/modules/$(KERNEL_VERSION)/updates/drivers/net/wireless/ath/carl9170

DESCRIPTION_kernel_module_rt73usb = Kernel module rt73usb
RDEPENDS_kernel_module_rt73usb = kernel_module_compat compat_rules firmware_rt73 kernel_module_mac80211 kernel_module_cfg80211
FILES_kernel_module_rt73usb = /lib/modules/$(KERNEL_VERSION)/updates/drivers/net/wireless/rt2x00/rt2x00* \
/lib/modules/$(KERNEL_VERSION)/updates/drivers/net/wireless/rt2x00/rt73usb.ko

call[[ ipkbox ]]

]]package
