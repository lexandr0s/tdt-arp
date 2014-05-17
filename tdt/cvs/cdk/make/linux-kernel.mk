############ Patches Kernel 24 ###############

ifdef ENABLE_P0207
PATCH_STR=_0207
endif

ifdef ENABLE_P0209
PATCH_STR=_0209
endif

ifdef ENABLE_P0210
PATCH_STR=_0210
endif

ifdef ENABLE_P0211
PATCH_STR=_0211
endif

ifdef ENABLE_P021
PATCH_STR=_0212
endif

STM24_DVB_PATCH = linux-sh4-linuxdvb_stm24$(PATCH_STR).patch

COMMONPATCHES_24 = \
		$(STM24_DVB_PATCH) \
		linux-sh4-sound_stm24$(PATCH_STR).patch \
		linux-sh4-time_stm24$(PATCH_STR).patch \
		linux-sh4-init_mm_stm24$(PATCH_STR).patch \
		linux-sh4-copro_stm24$(PATCH_STR).patch \
		linux-sh4-strcpy_stm24$(PATCH_STR).patch \
		linux-squashfs-lzma_stm24$(PATCH_STR).patch \
		linux-sh4-ext23_as_ext4_stm24$(PATCH_STR).patch \
		bpa2_procfs_stm24$(PATCH_STR).patch \
		$(if $(P0207),xchg_fix_stm24$(PATCH_STR).patch) \
		$(if $(P0207),mm_cache_update_stm24$(PATCH_STR).patch) \
		$(if $(P0207),linux-sh4-ehci_stm24$(PATCH_STR).patch) \
		linux-ftdi_sio.c_stm24$(PATCH_STR).patch \
		linux-sh4-lzma-fix_stm24$(PATCH_STR).patch \
		$(if $(P0209)$(P0210)$(P0211),linux-tune_stm24.patch) \
		$(if $(P0212),linux-tune_stm24_0212.patch) \
		$(if $(P0209)$(P0210)$(P0211)$(P0212),linux-sh4-mmap_stm24.patch) \
		$(if $(P0209),linux-sh4-dwmac_stm24_0209.patch) \
		$(if $(P0207),linux-sh4-sti7100_missing_clk_alias_stm24$(PATCH_STR).patch) \
		$(if $(P0209)$(P0211)$(P0212),linux-sh4-directfb_stm24$(PATCH_STR).patch) \
		patch_swap_notify_core_support.diff

HL101_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-hl101_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		$(if $(P0207)$(P0209)$(P0210)$(P0211),linux-sh4-hl101_i2c_st40_stm24$(PATCH_STR).patch)

SPARK_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-spark_setup_stm24$(PATCH_STR).patch \
		bpa2-ignore-bigphysarea-kernel-parameter.patch \
		$(if $(P0207),linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch) \
		$(if $(P0209),linux-sh4-linux_yaffs2_stm24_0209.patch) \
		$(if $(P0207)$(P0209),linux-sh4-lirc_stm.patch) \
		$(if $(P0210)$(P0211)$(P0212),linux-sh4-lirc_stm_stm24$(PATCH_STR).patch) \
		$(if $(P0211),linux-sh4-fix-crash-usb-reboot_stm24_0211.diff)

SPARK7162_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		bpa2-ignore-bigphysarea-kernel-parameter.patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-spark7162_setup_stm24$(PATCH_STR).patch \
		$(if $(P0211),linux-sh4-fix-crash-usb-reboot_stm24_0211.diff)

KERNELPATCHES_24 =  \
		$(if $(HL101),$(HL101_PATCHES_24)) \
		$(if $(SPARK),$(SPARK_PATCHES_24)) \
		$(if $(SPARK7162),$(SPARK7162_PATCHES_24))
	
############ Patches Kernel 24 End ###############

#
# KERNEL-HEADERS
#
$(DEPDIR)/kernel-headers: linux-kernel.do_prepare
	cd $(KERNEL_DIR) && \
		$(INSTALL) -d $(targetprefix)/usr/include && \
		cp -a include/linux $(targetprefix)/usr/include && \
		cp -a include/asm-sh $(targetprefix)/usr/include/asm && \
		cp -a include/asm-generic $(targetprefix)/usr/include && \
		cp -a include/mtd $(targetprefix)/usr/include
	touch $@

KERNELHEADERS := linux-kernel-headers
ifdef ENABLE_P0207
KERNELHEADERS_VERSION := 2.6.32.16-44
else
ifdef ENABLE_P0209
KERNELHEADERS_VERSION := 2.6.32.46-47
else
ifdef ENABLE_P0210
KERNELHEADERS_VERSION := 2.6.32.46-47
else
ifdef ENABLE_P0211
KERNELHEADERS_VERSION := 2.6.32.46-47
else
ifdef ENABLE_P0212
KERNELHEADERS_VERSION := 2.6.32.46-47
endif
endif
endif
endif
endif

KERNELHEADERS_SPEC := stm-target-kernel-headers-kbuild.spec
KERNELHEADERS_SPEC_PATCH :=
KERNELHEADERS_PATCHES :=
KERNELHEADERS_RPM := RPMS/noarch/$(STLINUX)-sh4-$(KERNELHEADERS)-$(KERNELHEADERS_VERSION).noarch.rpm

$(KERNELHEADERS_RPM): \
		$(if $(KERNELHEADERS_SPEC_PATCH),Patches/$(KERNELHEADERS_SPEC_PATCH)) \
		$(if $(KERNELHEADERS_PATCHES),$(KERNELHEADERS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(KERNELHEADERS)-$(KERNELHEADERS_VERSION).src.rpm \
		| linux-kernel.do_prepare
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(KERNELHEADERS_SPEC_PATCH),( cd SPECS && patch -p1 $(KERNELHEADERS_SPEC) < $(buildprefix)/Patches/$(KERNELHEADERS_SPEC_PATCH) ) &&) \
	$(if $(KERNELHEADERS_PATCHES),cp $(KERNELHEADERS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(KERNELHEADERS_SPEC)

$(DEPDIR)/max-$(KERNELHEADERS) \
$(DEPDIR)/$(KERNELHEADERS): \
$(DEPDIR)/%$(KERNELHEADERS): $(KERNELHEADERS_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# HOST-KERNEL
#
# IMPORTANT: it is expected that only one define is set
MODNAME = $(SPARK)$(SPARK7162)$(HL101)

ifdef DEBUG
DEBUG_STR=.debug
else
DEBUG_STR=
endif

HOST_KERNEL := host-kernel

ifdef ENABLE_P0207
HOST_KERNEL_VERSION = 2.6.32.28$(KERNELSTMLABEL)-$(KERNELLABEL)
else
ifdef ENABLE_P0209
HOST_KERNEL_VERSION = 2.6.32.46$(KERNELSTMLABEL)-$(KERNELLABEL)
else
ifdef ENABLE_P0210
HOST_KERNEL_VERSION = 2.6.32.57$(KERNELSTMLABEL)-$(KERNELLABEL)
else
ifdef ENABLE_P0211
HOST_KERNEL_VERSION = 2.6.32.59$(KERNELSTMLABEL)-$(KERNELLABEL)
else
ifdef ENABLE_P0212
HOST_KERNEL_VERSION = 2.6.32.61$(KERNELSTMLABEL)-$(KERNELLABEL)
endif
endif
endif
endif
endif

HOST_KERNEL_SPEC = stm-$(HOST_KERNEL)-sh4.spec
HOST_KERNEL_SPEC_PATCH =
HOST_KERNEL_PATCHES = $(KERNELPATCHES_24)
HOST_KERNEL_CONFIG = linux-sh4-$(subst _stm24_,-,$(KERNELVERSION))_$(MODNAME).config$(DEBUG_STR)
HOST_KERNEL_SRC_RPM = $(STLINUX)-$(HOST_KERNEL)-source-sh4-$(HOST_KERNEL_VERSION).src.rpm
HOST_KERNEL_RPM = RPMS/noarch/$(STLINUX)-$(HOST_KERNEL)-source-sh4-$(HOST_KERNEL_VERSION).noarch.rpm

#stlinux23

$(HOST_KERNEL_RPM): \
		$(if $(HOST_KERNEL_SPEC_PATCH),Patches/$(HOST_KERNEL_SPEC_PATCH)) \
		$(archivedir)/$(HOST_KERNEL_SRC_RPM)
	rpm $(DRPM) --nosignature --nodeps -Uhv $(lastword $^) && \
	$(if $(HOST_KERNEL_SPEC_PATCH),( cd SPECS; patch -p1 $(HOST_KERNEL_SPEC) < $(buildprefix)/Patches/$(HOST_KERNEL_SPEC_PATCH) ) &&) \
	rpmbuild $(DRPMBUILD) -ba -v --clean --target=sh4-linux SPECS/$(HOST_KERNEL_SPEC)

$(DEPDIR)/linux-kernel.do_prepare: \
		$(if $(HOST_KERNEL_PATCHES),$(HOST_KERNEL_PATCHES:%=Patches/%)) \
		$(HOST_KERNEL_RPM)
	@rpm $(DRPM) -ev $(HOST_KERNEL_SRC_RPM:%.src.rpm=%) || true
	rm -rf $(KERNEL_DIR)
	rm -rf linux{,-sh4}
	rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^)
	$(if $(HOST_KERNEL_PATCHES),cd $(KERNEL_DIR) && cat $(HOST_KERNEL_PATCHES:%=$(buildprefix)/Patches/%) | patch -p1)
	$(INSTALL) -m644 Patches/$(HOST_KERNEL_CONFIG) $(KERNEL_DIR)/.config
	-rm $(KERNEL_DIR)/localversion*
	echo "$(KERNELSTMLABEL)" > $(KERNEL_DIR)/localversion-stm
	if [ `grep -c "CONFIG_BPA2_DIRECTFBOPTIMIZED" $(KERNEL_DIR)/.config` -eq 0 ]; then echo "# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set" >> $(KERNEL_DIR)/.config; fi
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh oldconfig
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/asm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/linux/version.h
	rm $(KERNEL_DIR)/.config
	touch $@

ifdef ENABLE_GRAPHICFWDIRECTFB
GRAPHICFWDIRECTFB_SED_CONF=-i s"/^\# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set/CONFIG_BPA2_DIRECTFBOPTIMIZED=y/"
else
GRAPHICFWDIRECTFB_SED_CONF=-i s"/^CONFIG_BPA2_DIRECTFBOPTIMIZED=y/\# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set/"
endif

#dagobert: without stboard ->not sure if we need this
$(DEPDIR)/linux-kernel.do_compile: \
		bootstrap-cross \
		linux-kernel.do_prepare \
		Patches/$(HOST_KERNEL_CONFIG) \
		| $(HOST_U_BOOT_TOOLS)
	-rm $(DEPDIR)/linux-kernel*.do_compile
	cd $(KERNEL_DIR) && \
		export PATH=$(hostprefix)/bin:$(PATH) && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper && \
		@M4@ $(buildprefix)/Patches/$(HOST_KERNEL_CONFIG) > .config && \
	if [ `grep -c "CONFIG_BPA2_DIRECTFBOPTIMIZED" .config` -eq 0 ]; then echo "# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set" >> .config; fi && \
		sed $(GRAPHICFWDIRECTFB_SED_CONF) .config && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

NFS_FLASH_SED_CONF=$(foreach param,XCONFIG_NFS_FS XCONFIG_LOCKD XCONFIG_SUNRPC,-e s"/^.*$(param)[= ].*/$(param)=m/")

ifdef ENABLE_XFS
XFS_SED_CONF=$(foreach param,CONFIG_XFS_FS,-e s"/^.*$(param)[= ].*/$(param)=m/")
else
XFS_SED_CONF=-e ""
endif

ifdef ENABLE_NFSSERVER
#NFSSERVER_SED_CONF=$(foreach param,CONFIG_NFSD CONFIG_NFSD_V3 CONFIG_NFSD_TCP,-e s"/^.*$(param)[= ].*/$(param)=y/")
NFSSERVER_SED_CONF=$(foreach param,CONFIG_NFSD,-e s"/^.*$(param)[= ].*/$(param)=y\nCONFIG_NFSD_V3=y\n\# CONFIG_NFSD_V3_ACL is not set\n\# CONFIG_NFSD_V4 is not set\nCONFIG_NFSD_TCP=y/")
else
NFSSERVER_SED_CONF=-e ""
endif

ifdef ENABLE_NTFS
NTFS_SED_CONF=$(foreach param,CONFIG_NTFS_FS,-e s"/^.*$(param)[= ].*/$(param)=m/")
else
NTFS_SED_CONF=-e ""
endif

$(DEPDIR)/linux-kernel.cramfs.do_compile $(DEPDIR)/linux-kernel.squashfs.do_compile \
$(DEPDIR)/linux-kernel.jffs2.do_compile $(DEPDIR)/linux-kernel.usb.do_compile \
$(DEPDIR)/linux-kernel.focramfs.do_compile $(DEPDIR)/linux-kernel.fosquashfs.do_compile:
$(DEPDIR)/linux-kernel.%.do_compile: \
		bootstrap-cross \
		linux-kernel.do_prepare \
		Patches/linux-sh4-$(KERNELVERSION).stboards.c.m4 \
		Patches/$(HOST_KERNEL_CONFIG) \
		| $(DEPDIR)/$(HOST_U_BOOT_TOOLS)
	-rm $(DEPDIR)/linux-kernel*.do_compile
	cd $(KERNEL_DIR) && \
		export PATH=$(hostprefix)/bin:$(PATH) && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper && \
		@M4@ -Drootfs=$* --define=rootsize=$(ROOT_PARTITION_SIZE) --define=datasize=$(DATA_PARTITION_SIZE) ../$(word 3,$^) \
					> drivers/mtd/maps/stboards.c && \
		@M4@ --define=btldrdef=$* $(buildprefix)/Patches/$(HOST_KERNEL_CONFIG) \
					> .config && \
		sed $(NFS_FLASH_SED_CONF) -i .config && \
		sed $(XFS_SED_CONF) $(NFSSERVER_SED_CONF) $(NTFS_SED_CONF) -i .config && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

DESCRIPTION_linux_kernel = "The Linux Kernel and modules"
PACKAGE_ARCH_linux_kernel = $(box_arch)
PKGV_linux_kernel = $(KERNELVERSION)
PKGR_linux_kernel = r4
RDEPENDS_linux_kernel = devinit ustslave
SRC_URI_linux_kernel = stlinux.com
FILES_linux_kernel = \
/lib/modules/$(KERNELVERSION)/kernel \
/lib/modules/$(KERNELVERSION)/modules.* \
/boot/uImage

define postinst_linux_kernel
#!/bin/sh
flash_eraseall /dev/mtd5
nandwrite -p /dev/mtd5 /boot/uImage
rm /boot/uImage
depmod --basedir $$OPKG_OFFLINE_ROOT/ --all $(KERNELVERSION)
endef

$(DEPDIR)/linux-kernel: bootstrap $(DEPDIR)/linux-kernel.do_compile
	$(start_build)
	@$(INSTALL) -d $(PKDIR)/boot && \
	$(INSTALL) -d $(prefix)/$*$(notdir $(bootprefix)) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/arch/sh/boot/uImage $(prefix)/$*$(notdir $(bootprefix))/vmlinux.ub && \
	$(INSTALL) -m644 $(KERNEL_DIR)/vmlinux $(PKDIR)/boot/vmlinux-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/System.map $(PKDIR)/boot/System.map-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/COPYING $(PKDIR)/boot/LICENSE
	cp $(KERNEL_DIR)/arch/sh/boot/uImage $(PKDIR)/boot/
#if STM22
	echo -e "ST Linux Distribution - Binary Kernel\n \
	CPU: sh4\n \
	$(if $(HL101),PLATFORM: stb7109ref\n) \
	KERNEL VERSION: $(KERNELVERSION)\n" > $(PKDIR)/README.ST && \
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh INSTALL_MOD_PATH=$(PKDIR) modules_install && \
	rm $(PKDIR)/lib/modules/$(KERNELVERSION)/build || true && \
	rm $(PKDIR)/lib/modules/$(KERNELVERSION)/source || true
#else
#endif
	$(tocdk_build)
	$(toflash_build)
	touch $@

linux-kernel-distclean: $(KERNELHEADERS)-distclean

BEGIN[[
driver
  git
  {PN}-{PV}
  plink:$(driverdir):{PN}-{PV}
;
]]END

DESCRIPTION_driver = Drivers for stm box
RDEPENDS_driver = linux_kernel
SRC_URI_driver = "http://gitorious.org/~schpuntik/open-duckbox-project-sh4/tdt-amiko"

define postinst_driver
#!/bin/sh
	depmod --basedir $$OPKG_OFFLINE_ROOT/ --all $(KERNELVERSION) || true
endef

PACKAGE_ARCH_driver = $(box_arch)
PACKAGES_driver = kernel_module_avs \
		  kernel_module_bpamem \
		  kernel_module_cec \
		  kernel_module_compcache \
		  kernel_module_cpu_frequ \
		  kernel_module_e2_proc \
		  kernel_module_encrypt \
		  kernel_module_frontcontroller \
		  kernel_module_frontends \
		  kernel_module_multicom \
		  kernel_module_player2 \
		  kernel_module_pti \
		  kernel_module_ptinp \
		  kernel_module_simu_button \
		  kernel_module_smartcard \
		  kernel_module_stgfb \
		  kernel_module_rt2870sta \
		  kernel_module_rt3070sta \
		  kernel_module_rt5370sta \
		  kernel_module_rtl8192cu \
		  kernel_module_rtl871x \
		  kernel_module_rtl8188eu

DESCRIPTION_kernel_module_avs = For av receiver without av switch. the e2_core in stmdvb need some functions \
from avs module but fake_avs is not a real fake because it sets pio pins.
FILES_kernel_module_avs = /lib/modules/$(KERNELVERSION)/extra/avs

DESCRIPTION_kernel_module_bpamem = bpamem driver
FILES_kernel_module_bpamem = /lib/modules/$(KERNELVERSION)/extra/bpamem

DESCRIPTION_kernel_module_cec = HdmiCEC  driver for multimedia devices control
FILES_kernel_module_cec = /lib/modules/$(KERNELVERSION)/extra/cec

DESCRIPTION_kernel_module_compcache = The zram module creates RAM based block devices named /dev/zram<id>
FILES_kernel_module_compcache = /lib/modules/$(KERNELVERSION)/extra/compcache

DESCRIPTION_kernel_module_cpu_frequ = CPU overclocking driver
FILES_kernel_module_cpu_frequ = /lib/modules/$(KERNELVERSION)/extra/cpu_frequ

DESCRIPTION_kernel_module_e2_proc = /proc driver for control  devices
FILES_kernel_module_e2_proc = /lib/modules/$(KERNELVERSION)/extra/e2_proc

DESCRIPTION_kernel_module_encrypt = driver encrypt
FILES_kernel_module_encrypt = /lib/modules/$(KERNELVERSION)/extra/encrypt

DESCRIPTION_kernel_module_frontcontroller = frontcontroller driver for control  devices
RDEPENDS_kernel_module_frontcontroller = fp_control
FILES_kernel_module_frontcontroller = /lib/modules/$(KERNELVERSION)/extra/frontcontroller

DESCRIPTION_kernel_module_frontends = frontends driver for control  devices
FILES_kernel_module_frontends = /lib/modules/$(KERNELVERSION)/extra/frontends

DESCRIPTION_kernel_module_multicom = stm-multicom driver for control  devices
RDEPENDS_kernel_module_multicom = libmme-host libmmeimage
FILES_kernel_module_multicom = /lib/modules/$(KERNELVERSION)/extra/multicom

DESCRIPTION_kernel_module_player2 = frontends driver for control  devices
RDEPENDS_kernel_module_player2 = libmmeimage
FILES_kernel_module_player2 = /lib/modules/$(KERNELVERSION)/extra/player2

DESCRIPTION_kernel_module_pti = open source st-pti kernel module
RCONFLICTS_kernel_module_pti = kernel_module_ptinp
FILES_kernel_module_pti = /lib/modules/$(KERNELVERSION)/extra/pti

DESCRIPTION_kernel_module_ptinp = pti non public
RCONFLICTS_kernel_module_ptinp = kernel_module_pti
FILES_kernel_module_ptinp = lib/modules/$(KERNELVERSION)/extra/pti_np

DESCRIPTION_kernel_module_simu_button = simu-button driver for control  devices
FILES_kernel_module_simu_button = /lib/modules/$(KERNELVERSION)/extra/simu_button

DESCRIPTION_kernel_module_smartcard = smartcard driver for control  devices
FILES_kernel_module_smartcard = /lib/modules/$(KERNELVERSION)/extra/smartcard

DESCRIPTION_kernel_module_stgfb = stgfb driver for control  devices
RDEPENDS_kernel_module_stgfb = stfbcontrol
FILES_kernel_module_stgfb = /lib/modules/$(KERNELVERSION)/extra/stgfb

DESCRIPTION_kernel_module_rt2870sta = rt2870sta frontends driver for control wireless devices
FILES_kernel_module_rt2870sta = /lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta
RDEPENDS_kernel_module_rt2870sta = wlan_firmware firmware-rt2870

DESCRIPTION_kernel_module_rt3070sta = rt3070sta driver for control wireless devices
FILES_kernel_module_rt3070sta = /lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta
RDEPENDS_kernel_module_rt3070sta = wlan_firmware firmware-rt3070

DESCRIPTION_kernel_module_rt5370sta = rt5370sta driver for control wireless devices
FILES_kernel_module_rt5370sta = /lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta
RDEPENDS_kernel_module_rt5370sta = wlan_firmware

DESCRIPTION_kernel_module_rtl8192cu = rtl8192cu driver for control wireless devices
FILES_kernel_module_rtl8192cu = /lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu
RDEPENDS_kernel_module_rtl8192cu = firmware-rtl8192cu

DESCRIPTION_kernel_module_rtl871x = rtl871x driver for control wifi devices
FILES_kernel_module_rtl871x = /lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x
RDEPENDS_kernel_module_rtl871x = firmware-rtl8712u

DESCRIPTION_kernel_module_rtl8188eu = rtl8188eu driver for control wifi  devices
FILES_kernel_module_rtl8188eu = /lib/modules/$(KERNELVERSION)/extra/wireless/rtl8188eu
RDEPENDS_kernel_module_rtl8188eu = firmware-rtl8188eu

$(DEPDIR)/driver: $(DEPENDS_driver) $(driverdir)/Makefile glibc-dev wlanfirmware firmware_rtl8188eu linux-kernel.do_compile
	$(PREPARE_driver)
#	$(MAKE) -C $(KERNEL_DIR) $(MAKE_OPTS) ARCH=sh modules_prepare
	$(start_build)
	$(get_git_version)
	$(eval export PKGV_driver = $(KERNELLABEL)-$(PKGV_driver))
	$(if $(PLAYER179),cp $(driverdir)/stgfb/stmfb/linux/drivers/video/stmfb.h $(targetprefix)/usr/include/linux)
	$(if $(PLAYER191),cp $(driverdir)/stgfb/stmfb/linux/drivers/video/stmfb.h $(targetprefix)/usr/include/linux)
	cp $(driverdir)/player2/linux/include/linux/dvb/stm_ioctls.h $(targetprefix)/usr/include/linux/dvb
	#$(LN_SF) $(driverdir)/wireless/rtl8192cu/autoconf_rtl8192c_usb_linux.h $(buildprefix)/
	$(MAKE) -C $(driverdir) ARCH=sh \
		CONFIG_MODULES_PATH=$(targetprefix) \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		DRIVER_TOPDIR=$(driverdir) \
		$(if $(HL101),HL101=$(HL101)) \
		$(if $(SPARK),SPARK=$(SPARK)) \
		$(if $(SPARK7162),SPARK7162=$(SPARK7162)) \
		$(if $(PLAYER179),PLAYER179=$(PLAYER179)) \
		$(if $(PLAYER191),PLAYER191=$(PLAYER191)) \
		CROSS_COMPILE=$(target)-
	$(MAKE) -C $(driverdir) ARCH=sh \
		CONFIG_MODULES_PATH=$(targetprefix) \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		DRIVER_TOPDIR=$(driverdir) \
		BIN_DEST=$(PKDIR)/bin \
		INSTALL_MOD_PATH=$(PKDIR) \
		DEPMOD=$(DEPMOD) \
		$(if $(HL101),HL101=$(HL101)) \
		$(if $(SPARK),SPARK=$(SPARK)) \
		$(if $(SPARK7162),SPARK7162=$(SPARK7162)) \
		$(if $(PLAYER179),PLAYER179=$(PLAYER179)) \
		$(if $(PLAYER191),PLAYER191=$(PLAYER191)) \
		install
	$(DEPMOD) -ae -b $(PKDIR) -F $(buildprefix)/$(KERNEL_DIR)/System.map -r $(KERNELVERSION)
	$(tocdk_build)
# required := for following ifdef checks
ifeq (,$(wildcard $(DRIVER_TOPDIR)/pti_np ))
	$(INSTALL_DIR) $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti
ifdef ENABLE_HL101
	$(if $(P0210),cp -dp $(archivedir)/ptinp/ptif_210.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/ptif_211.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko)
endif	
ifdef ENABLE_SPARK
	$(if $(P0210),cp -dp $(archivedir)/ptinp/ptif_210.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/ptif_211.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko)
endif
ifdef ENABLE_SPARK7162
	$(if $(P0210),cp -dp $(archivedir)/ptinp/pti_210s2.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/ptif_211s2.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko)
endif
else
	$(INSTALL_DIR) $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np
ifdef ENABLE_HL101
	$(if $(P0210),cp -dp $(archivedir)/ptinp/pti_210.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/pti_211.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko)
endif	
ifdef ENABLE_SPARK
	$(if $(P0210),cp -dp $(archivedir)/ptinp/pti_210.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/pti_211.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko)
endif
ifdef ENABLE_SPARK7162
	$(if $(P0210),cp -dp $(archivedir)/ptinp/pti_210s2.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/pti_211s2.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko)
endif
endif
	$(INSTALL_DIR) $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/encrypt
ifdef ENABLE_SPARK
	$(if $(P0210), cp -dp $(buildprefix)/root/release/encrypt_spark_stm24_0210.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/encrypt/encrypt.ko) \
	$(if $(P0211), cp -dp $(buildprefix)/root/release/encrypt_spark_stm24_0211.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/encrypt/encrypt.ko)
endif
ifdef ENABLE_SPARK7162
	$(if $(P0210), cp -dp $(buildprefix)/root/release/encrypt_spark7162_stm24_0210.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/encrypt/encrypt.ko) \
	$(if $(P0211), cp -dp $(buildprefix)/root/release/encrypt_spark7162_stm24_0211.ko $(PKDIR)/lib/modules/$(KERNELVERSION)/extra/encrypt/encrypt.ko)
endif
	$(toflash_build)
	touch $@

# overwrite make driver-distclean
define DISTCLEANUP_driver
	rm -f $(DEPDIR)/driver
	rm -f $(buildprefix)/autoconf_rtl8192c_usb_linux.h
	$(MAKE) -C $(driverdir) ARCH=sh \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		distclean
endef
define DEPSCLEANUP_driver
	rm -f $(DEPDIR)/driver
	rm -f $(buildprefix)/autoconf_rtl8192c_usb_linux.h
	$(MAKE) -C $(driverdir) ARCH=sh \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		distclean
endef

#------------------- Helper

linux-kernel.menuconfig linux-kernel.xconfig: \
linux-kernel.%:
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh CROSS_COMPILE=sh4-linux- $*
	@echo
	@echo "You have to edit m a n u a l l y Patches/linux-$(KERNELVERSION).config to make changes permanent !!!"
	@echo ""
	diff $(KERNEL_DIR)/.config.old $(KERNEL_DIR)/.config
	@echo ""
#-------------------

#
# boot-elf
#
BEGIN[[
bootelf
  0.4
  {PN}-{PV}
;
]]END

NAME_bootelf = boot-elf
PACKAGE_ARCH_bootelf = $(box_arch)
DESCRIPTION_bootelf = firmware non public
SRC_URI_bootelf = unknown
RDEPENDS_bootelf = filesystem


$(DEPDIR)/bootelf: firmware filesystemtarget $(DEPENDS_bootelf)
	$(start_build)
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/
	$(INSTALL_DIR) $(PKDIR)/boot/
ifdef ENABLE_SPARK
	$(INSTALL_FILE) $(archivedir)/boot/video_7111.elf $(PKDIR)/boot/video.elf
	$(INSTALL_FILE) $(archivedir)/boot/audio_7111.elf $(PKDIR)/boot/audio.elf
	ln -sf /boot/video.elf $(PKDIR)/lib/firmware/video.elf
	ln -sf /boot/audio.elf $(PKDIR)/lib/firmware/audio.elf
endif
ifdef ENABLE_SPARK7162
	$(INSTALL_FILE) $(archivedir)/boot/video_7111.elf $(PKDIR)/boot/video.elf
	$(INSTALL_FILE) $(archivedir)/boot/audio_7111.elf $(PKDIR)/boot/audio.elf
	ln -sf /boot/video.elf $(PKDIR)/lib/firmware/video.elf
	ln -sf /boot/audio.elf $(PKDIR)/lib/firmware/audio.elf
endif
ifdef ENABLE_HL101
	$(INSTALL_FILE) $(archivedir)/boot/video_7109.elf $(PKDIR)/boot/video.elf
	$(INSTALL_FILE) $(archivedir)/boot/audio_7109.elf $(PKDIR)/boot/audio.elf
	ln -sf /boot/video.elf $(PKDIR)/lib/firmware/video.elf
	ln -sf /boot/audio.elf $(PKDIR)/lib/firmware/audio.elf
endif
	$(toflash_build)
	touch $@

#
# firmware
#
BEGIN[[
firmware
 0.1
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/firmware/component_7111_mb618.fw
  nothing:file://../root/firmware/component_7105_pdk7105.fw
  nothing:file://../root/firmware/dvb-fe-avl2108.fw
  nothing:file://../root/firmware/dvb-fe-stv6306.fw
  nothing:file://../root/release/fstab_hl101
;
]]END

DESCRIPTION_firmware = firmware non public
PACKAGE_ARCH_firmware = $(box_arch)
SRC_URI_firmware = stlinux.com
RDEPENDS_firmware := filesystem
FILES_firmware = /lib/firmware/component.fw \
		 /etc/hostname \
		 /etc/fstab

$(DEPDIR)/firmware:  $(DEPENDS_firmware)
	$(PREPARE_firmware)
	$(start_build)
ifdef ENABLE_SPARK
	cd $(DIR_firmware) && \
	$(INSTALL_DIR) $(PKDIR)/etc/ && \
	echo $(box_arch) > $(PKDIR)/etc/hostname && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) component_7111_mb618.fw $(PKDIR)/lib/firmware/component.fw
endif
ifdef ENABLE_SPARK7162
	cd $(DIR_firmware) && \
	$(INSTALL_DIR) $(PKDIR)/etc/ && \
	echo $(box_arch) > $(PKDIR)/etc/hostname && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) component_7105_pdk7105.fw $(PKDIR)/lib/firmware/component.fw
endif
ifdef ENABLE_HL101
	cd $(DIR_firmware) && \
	$(INSTALL_DIR) $(PKDIR)/etc/ && \
	echo $(box_arch) > $(prefix)/release/etc/hostname && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) fstab_hl101 $(PKDIR)/etc/fstab && \
	$(INSTALL_FILE) dvb-fe-avl2108.fw $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) dvb-fe-stv6306.fw $(PKDIR)/lib/firmware/
endif
	$(toflash_build)
	touch $@

#
#  wlan-firmware
#
BEGIN[[
wlanfirmware
 0.1
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/Wireless/RT2870STA/RT2870STA.dat
  nothing:file://../root/etc/Wireless/RT3070STA/RT3070STA.dat
;
]]END

NAME_wlanfirmware = wlan-firmware
DESCRIPTION_wlanfirmware = Wlan firmware  for  rt2870sta rt3070sta rt5370sta

$(DEPDIR)/wlanfirmware: $(DEPENDS_wlanfirmware)
	$(PREPARE_wlanfirmware)
	$(start_build)
	cd $(DIR_wlanfirmware) && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/RT2870STA/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/RT3070STA/ && \
	$(INSTALL_FILE) RT2870STA.dat $(PKDIR)/etc/Wireless/RT2870STA/ && \
	$(INSTALL_FILE) RT3070STA.dat $(PKDIR)/etc/Wireless/RT3070STA/
	$(toflash_build)
	touch $@

#
#  firmware-rtl8188eu
#
BEGIN[[
firmware_rtl8188eu
 0.1
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../../driver/wireless/rtl8188eu/rtl8188eufw.bin
;
]]END

NAME_firmware_rtl8188eu = firmware-rtl8188eu
PACKAGE_ARCH_irmware_rtl8188eu = all
DESCRIPTION_firmware_rtl8188eu = Wlan firmware  for  rtl8188eu

$(DEPDIR)/firmware_rtl8188eu: $(DEPENDS_firmware_rtl8188eu)
	$(PREPARE_firmware_rtl8188eu)
	$(start_build)
	cd $(DIR_firmware_rtl8188eu) && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/rtlwifi && \
	$(INSTALL_FILE) rtl8188eufw.bin $(PKDIR)/lib/firmware/rtlwifi/
	$(toflash_build)
	touch $@
