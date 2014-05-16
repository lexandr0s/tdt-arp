#
# LINUX KERNEL
#
function[[ target_linux_kernel_in

PV_${P} = $(KERNEL_VERSION)
PR_${P} = 5

DIR_${P} = $(WORK_target_linux_kernel)/linux-kernel-${PV}
PACKAGE_ARCH_${P} = $(box_arch)
SRC_URI_${P} = stlinux.com

]]function

package[[ target_linux_kernel

BDEPENDS_${P} = $(target_glibc) $(cross_kernel) $(host_u_boot_tools)

call[[ target_linux_kernel_in ]]
call[[ base ]]

${P}_patches = 

ifdef CONFIG_HL101
  ${P}_patches += linux-sh4-hl101_setup_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-usbwait123_stm24.patch
  ${P}_patches += linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-i2c-st40-pio_stm24_$(KERNEL_LABEL).patch
ifeq ($(CONFIG_KERNEL_207)$(CONFIG_KERNEL_209)$(CONFIG_KERNEL_210)$(CONFIG_KERNEL_211)$(CONFIG_KERNEL_212)$(CONFIG_KERNEL_214),y)
  ${P}_patches += linux-sh4-hl101_i2c_st40_stm24_$(KERNEL_LABEL).patch)
endif
endif #CONFIG_HL101

ifdef CONFIG_SPARK
  ${P}_patches += linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-lmb_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-spark_setup_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += bpa2-ignore-bigphysarea-kernel-parameter.patch
ifeq ($(CONFIG_KERNEL_207),y)
  ${P}_patches += linux-sh4-i2c-stm-downgrade_stm24_$(KERNEL_LABEL).patch
endif
ifeq ($(CONFIG_KERNEL_209),y)
  ${P}_patches += linux-sh4-linux_yaffs2_stm24_0209.patch
endif
ifeq ($(CONFIG_KERNEL_207)$(CONFIG_KERNEL_209),y)
  ${P}_patches += linux-sh4-lirc_stm.patch
endif
ifeq ($(CONFIG_KERNEL_210)$(CONFIG_KERNEL_211)$(CONFIG_KERNEL_212)$(CONFIG_KERNEL_214),y)
  ${P}_patches += linux-sh4-lirc_stm_stm24_$(KERNEL_LABEL).patch
endif
ifeq ($(CONFIG_KERNEL_211)$(CONFIG_KERNEL_214),y)
  ${P}_patches += linux-sh4-fix-crash-usb-reboot_stm24_0211.diff
endif
endif #CONFIG_SPARK

ifdef CONFIG_SPARK7162
  ${P}_patches += linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += bpa2-ignore-bigphysarea-kernel-parameter.patch
  ${P}_patches += linux-sh4-lmb_stm24_$(KERNEL_LABEL).patch
  ${P}_patches += linux-sh4-spark7162_setup_stm24_$(KERNEL_LABEL).patch
ifeq ($(CONFIG_KERNEL_211)$(CONFIG_KERNEL_214),y)
  ${P}_patches += linux-sh4-fix-crash-usb-reboot_stm24_0211.diff
endif
endif #CONFIG_SPARK7162

${P}_config = linux-sh4-$(KERNEL_UPSTREAM)-$(KERNEL_LABEL)_$(TARGET).config$(DEBUG_STR)

DEPENDS_${P} += $(addprefix ${SDIR}/,$(${P}_patches) $(${P}_config))

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	cp -ar $(crossprefix)/sources/kernel $(DIR_${P})
	cd $(DIR_${P}) && cat $(addprefix ${SDIR}/,$(${P}_patches)) | patch -p1
	cd $(DIR_${P}) && $(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper
# FIXME:
	ln -sf ${SDIR}/integrated_firmware $(DIR_${P})/../integrated_firmware

	cp ${SDIR}/$(${P}_config) $(DIR_${P})/.config
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(MAKE) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	install -d $(PKDIR)/boot
	cp $(DIR_${P})/arch/sh/boot/uImage $(PKDIR)/boot/
	cd $(DIR_${P}) && $(MAKE) ARCH=sh INSTALL_MOD_PATH=$(PKDIR) modules_install

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

BREPLACES_${P} = $(target_kernel_headers)

call[[ target_linux_kernel_in ]]
call[[ base ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P})
	$(PKDIR_clean)
	cd $(DIR_${P}) && make ARCH=sh INSTALL_HDR_PATH=$(PKDIR)/usr headers_install
	rm -rf $(PKDIR)/usr/include/scsi
	touch $@

call[[ ipk ]]

]]package
