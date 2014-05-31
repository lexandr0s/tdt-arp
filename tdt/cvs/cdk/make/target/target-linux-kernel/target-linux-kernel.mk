#
# LINUX KERNEL
#

KERNEL_UPSTREAM_SPLITED := $(subst ., ,$(KERNEL_UPSTREAM))
KERNEL_MAJOR := \
	$(word 1,$(KERNEL_UPSTREAM_SPLITED)).$(word 2,$(KERNEL_UPSTREAM_SPLITED)).$(word 3,$(KERNEL_UPSTREAM_SPLITED))
KERNEL_MINOR := \
	$(word 4,$(KERNEL_UPSTREAM_SPLITED))

ifdef MAKE_DEBUG
$(info '$(KERNEL_VERSION)')
$(info '$(KERNEL_MAJOR)')
$(info '$(KERNEL_MINOR)')
$(info '$(KERNEL_RELEASE)')
$(info '$(KERNEL_LABEL)')
endif

function[[ target_linux_kernel_in

PV_${P} = $(KERNEL_VERSION)
PR_${P} = 8

DIR_${P} = $(WORK_target_linux_kernel)/linux-$(KERNEL_MAJOR)
PACKAGE_ARCH_${P} = $(box_arch)
SRC_URI_${P} = stlinux.com

MAKE_FLAGS_${P} = ARCH=sh CROSS_COMPILE=$(target)-

]]function

package[[ target_linux_kernel

BDEPENDS_${P} = $(target_glibc) $(host_u_boot_tools)

call[[ target_linux_kernel_in ]]
call[[ base ]]

# common sh4 patches
#############################################################################

${P}_patches = \
	linux-sh4-linuxdvb_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-sound_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-time_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-init_mm_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-copro_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-strcpy_stm24_$(KERNEL_LABEL).patch \
	linux-squashfs-lzma_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-ext23_as_ext4_stm24_$(KERNEL_LABEL).patch \
	bpa2_procfs_stm24_$(KERNEL_LABEL).patch

ifeq ($(CONFIG_KERNEL_0207),y)
${P}_patches += \
	xchg_fix_stm24_$(KERNEL_LABEL).patch) \
	mm_cache_update_stm24_$(KERNEL_LABEL).patch) \
	linux-sh4-ehci_stm24_$(KERNEL_LABEL).patch
endif

${P}_patches += \
	linux-ftdi_sio.c_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-lzma-fix_stm24_$(KERNEL_LABEL).patch

ifeq ($(CONFIG_KERNEL_0209)$(CONFIG_KERNEL_0210)$(CONFIG_KERNEL_0211),y)
${P}_patches += linux-tune_stm24.patch
endif

ifeq ($(CONFIG_KERNEL_0212),y)
${P}_patches += linux-tune_stm24_0212.patch
endif

ifeq ($(CONFIG_KERNEL_0209)$(CONFIG_KERNEL_0210)$(CONFIG_KERNEL_0211)$(CONFIG_KERNEL_0212),y)
${P}_patches += linux-sh4-mmap_stm24.patch
endif

ifeq ($(CONFIG_KERNEL_0209),y)
${P}_patches += linux-sh4-dwmac_stm24_0209.patch
endif

ifeq ($(CONFIG_KERNEL_0207),y)
${P}_patches += linux-sh4-sti7100_missing_clk_alias_stm24_$(KERNEL_LABEL).patch
endif

ifeq ($(CONFIG_KERNEL_0209)$(CONFIG_KERNEL_0211)$(CONFIG_KERNEL_0212),y)
${P}_patches += linux-sh4-directfb_stm24_$(KERNEL_LABEL).patch
endif

${P}_patches += patch_swap_notify_core_support.diff


# TARGET specific patches
#############################################################################

ifdef CONFIG_HL101
  ${P}_patches += linux-sh4-hl101_setup_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-usbwait123_stm24.patch
  ${P}_patches += linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-i2c-st40-pio_stm24_$(KERNEL_LABEL).patch
ifeq ($(CONFIG_KERNEL_0207)$(CONFIG_KERNEL_0209)$(CONFIG_KERNEL_0210)$(CONFIG_KERNEL_0211),y)
  ${P}_patches += linux-sh4-hl101_i2c_st40_stm24_$(KERNEL_LABEL).patch)
endif
endif #CONFIG_HL101

ifdef CONFIG_SPARK
  ${P}_patches += linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-lmb_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-spark_setup_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += bpa2-ignore-bigphysarea-kernel-parameter.patch
ifeq ($(CONFIG_KERNEL_0207),y)
  ${P}_patches += linux-sh4-i2c-stm-downgrade_stm24_$(KERNEL_LABEL).patch
endif
ifeq ($(CONFIG_KERNEL_0209),y)
  ${P}_patches += linux-sh4-linux_yaffs2_stm24_0209.patch
endif
ifeq ($(CONFIG_KERNEL_0207)$(CONFIG_KERNEL_0209),y)
  ${P}_patches += linux-sh4-lirc_stm.patch
endif
ifeq ($(CONFIG_KERNEL_0210)$(CONFIG_KERNEL_0211)$(CONFIG_KERNEL_0212),y)
  ${P}_patches += linux-sh4-lirc_stm_stm24_$(KERNEL_LABEL).patch
endif
ifeq ($(CONFIG_KERNEL_0211),y)
  ${P}_patches += linux-sh4-fix-crash-usb-reboot_stm24_0211.diff
endif
endif #CONFIG_SPARK

ifdef CONFIG_SPARK7162
  ${P}_patches += linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += bpa2-ignore-bigphysarea-kernel-parameter.patch
  ${P}_patches += linux-sh4-lmb_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-spark7162_setup_stm24_$(KERNEL_LABEL).patch
ifeq ($(CONFIG_KERNEL_0211),y)
  ${P}_patches += linux-sh4-fix-crash-usb-reboot_stm24_0211.diff
endif
endif #CONFIG_SPARK7162

#############################################################################
# end patches

${P}_config = linux-sh4-$(KERNEL_UPSTREAM)-$(KERNEL_LABEL)_$(TARGET).config$(DEBUG_STR)

DEPENDS_${P} += $(addprefix ${SDIR}/,$(${P}_patches) $(${P}_config))

rule[[
  dirextract:local://$(archivedir)/$(STLINUX)-host-kernel-source-sh4-$(KERNEL_VERSION)-$(KERNEL_RELEASE).src.rpm
  extract:localwork://${DIR}/linux-$(KERNEL_MAJOR).tar.bz2
# don't forget to check on version update, but usually .src.rpm has these 2 patches
  patch:localwork://${DIR}/linux-$(KERNEL_UPSTREAM).patch.bz2
  patch:localwork://${DIR}/linux-$(KERNEL_UPSTREAM)_$(KERNEL_STM)_sh4_$(KERNEL_LABEL).patch.bz2
# TODO: add patches
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})

	cd $(DIR_${P}) && cat $(addprefix ${SDIR}/,$(${P}_patches)) | patch -p1
	cd $(DIR_${P}) && $(MAKE) ${MAKE_FLAGS} mrproper
# FIXME:
	ln -sf ${SDIR}/integrated_firmware $(DIR_${P})/../integrated_firmware

	cp ${SDIR}/$(${P}_config) $(DIR_${P})/.config
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(MAKE) ${MAKE_FLAGS} uImage modules
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	install -d $(PKDIR)/boot
	cp $(DIR_${P})/arch/sh/boot/uImage $(PKDIR)/boot/
	cd $(DIR_${P}) && $(MAKE) ${MAKE_FLAGS} INSTALL_MOD_PATH=$(PKDIR) modules_install

# provide this dir to build external modules (target_driver)
#	rm -rf $(PKDIR)/lib/modules/$(KERNEL_VERSION)/build
	rm -rf $(PKDIR)/lib/modules/$(KERNEL_VERSION)/source
	rm -rf $(PKDIR)/lib/modules/$(KERNEL_VERSION)/modules.*

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = The Linux Kernel and modules
FILES_${P} = \
	/lib/modules/$(KERNEL_VERSION)/kernel \
	/lib/modules/$(KERNEL_VERSION)/modules.* \
	/boot/uImage

define postinst_${P}
#!/bin/sh
if [ -z "$$OPKG_OFFLINE_ROOT" ]; then
  flash_eraseall /dev/mtd5
  nandwrite -p /dev/mtd5 /boot/uImage
  rm /boot/uImage
fi
depmod -b $$OPKG_OFFLINE_ROOT/ -a $(KERNEL_VERSION)
endef

call[[ ipkbox ]]

call[[ TARGET_base_do_config ]]

]]package

package[[ target_linux_kernel_headers

DEPENDS_${P} = $(target_linux_kernel).do_prepare

BDEPENDS_${P} = $(target_filesystem)
BREPLACES_${P} = $(target_kernel_headers)

call[[ target_linux_kernel_in ]]
call[[ base ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P})
	$(PKDIR_clean)
	cd $(DIR_${P}) && make ${MAKE_FLAGS} INSTALL_HDR_PATH=$(PKDIR)/usr headers_install
	rm -rf $(PKDIR)/usr/include/scsi
	touch $@

call[[ ipk ]]

]]package
