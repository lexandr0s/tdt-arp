#
# AR-P buildsystem smart Makefile
#
function[[ target_driver_common

PV_${P} = git
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Drivers for stm box
SRC_URI_${P} = http://gitorious.org/~schpuntik/open-duckbox-project-sh4/tdt-amiko

GIT_DIR_${P} = $(driverdir)

]]function

package[[ target_driver

call[[ target_driver_common ]]

BDEPENDS_${P} = $(target_linux_kernel_headers) $(target_linux_kernel)
PR_${P} = 1

call[[ base ]]

rule[[
  pdircreate:${DIR}
  plndir:$(driverdir):${DIR}
]]rule

call[[ git ]]

MAKE_FLAGS_${P} = \
	ARCH=sh \
	CROSS_COMPILE=$(target)- \
	CONFIG_MODULES_PATH=$(targetprefix) \
	KERNEL_LOCATION=$(targetprefix)/lib/modules/$(KERNEL_VERSION)/build \
	DRIVER_TOPDIR=$(DIR_${P}) \
	BIN_DEST=$(PKDIR)/bin \
	INSTALL_MOD_PATH=$(PKDIR) \
	DEPMOD=$(DEPMOD) \
	$(if $(CONFIG_HL101),HL101=y) \
	$(if $(CONFIG_SPARK),SPARK=y) \
	$(if $(CONFIG_SPARK7162),SPARK7162=y) \
	$(if $(CONFIG_PLAYER191),PLAYER191=y)


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
#	$(MAKE) -C $(KERNEL_DIR) ${MAKE_FLAGS} ARCH=sh modules_prepare

	echo "# Automatically generated config: don't edit" > ${DIR}/.config
	echo "export CONFIG_PLAYER_191=y" >> ${DIR}/.config

# TODO:
	rm -f ${DIR}/include/multicom
	rm -f ${DIR}/multicom
ifdef CONFIG_MULTICOM324
	echo "export CONFIG_MULTICOM324=y" >> ${DIR}/.config
	ln -sf ../multicom-3.2.4/include ${DIR}/include/multicom
	ln -sf multicom-3.2.4 ${DIR}/multicom
endif
ifdef CONFIG_MULTICOM406
	ln -sf ../multicom-4.0.6/include ${DIR}/include/multicom
	ln -sf multicom-4.0.6 ${DIR}/multicom
	echo "export CONFIG_MULTICOM406=y" >> ${DIR}/.config
endif
	touch $@


$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && make $(MAKE_FLAGS_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make $(MAKE_FLAGS_${P}) install

# copy free pti ko if we have built pti_np
ifdef CONFIG_PTINP_SRC
	install -d $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/pti
ifeq ($(CONFIG_HL101)$(CONFIG_SPARK),y)
	cp -dp $(archivedir)/ptinp/ptif_$(KERNEL_RELEASE).ko $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/pti/pti.ko
endif
ifdef CONFIG_SPARK7162
	cp -dp $(archivedir)/ptinp/ptif_$(KERNEL_RELEASE)s2.ko $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/pti/pti.ko
endif
# copy pti_np ko if we have built free pti
else #CONFIG_PTINP_SRC
	install -d $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/pti_np
ifeq ($(CONFIG_HL101)$(CONFIG_SPARK),y)
	cp -dp $(archivedir)/ptinp/pti_$(KERNEL_RELEASE).ko $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/pti_np/pti.ko
endif
ifdef CONFIG_SPARK7162
	cp -dp $(archivedir)/ptinp/pti_$(KERNEL_RELEASE)s2.ko $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/pti_np/pti.ko
endif
endif #CONFIG_PTINP_SRC

#	install -d $(PKDIR)/lib/modules/$(KERNEL_VERSION)/extra/encrypt
#	cp -dp $(buildprefix)/root/release/encrypt_$(TARGET)_stm24_$(KERNEL_LABEL).ko

	touch $@

call[[ ipk ]]

RDEPENDS_${P} = linux-kernel

define postinst_${P}
#!/bin/sh
depmod -b $$OPKG_OFFLINE_ROOT/ -a $(KERNEL_VERSION)
endef

PACKAGES_${P} = \
	kernel_module_avs \
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
FILES_kernel_module_avs = /lib/modules/$(KERNEL_VERSION)/extra/avs

DESCRIPTION_kernel_module_bpamem = bpamem driver
FILES_kernel_module_bpamem = /lib/modules/$(KERNEL_VERSION)/extra/bpamem

DESCRIPTION_kernel_module_cec = HdmiCEC  driver for multimedia devices control
FILES_kernel_module_cec = /lib/modules/$(KERNEL_VERSION)/extra/cec

DESCRIPTION_kernel_module_compcache = The zram module creates RAM based block devices named /dev/zram<id>
FILES_kernel_module_compcache = /lib/modules/$(KERNEL_VERSION)/extra/compcache

DESCRIPTION_kernel_module_cpu_frequ = CPU overclocking driver
FILES_kernel_module_cpu_frequ = /lib/modules/$(KERNEL_VERSION)/extra/cpu_frequ

DESCRIPTION_kernel_module_e2_proc = /proc driver for control  devices
FILES_kernel_module_e2_proc = /lib/modules/$(KERNEL_VERSION)/extra/e2_proc

DESCRIPTION_kernel_module_encrypt = driver encrypt
FILES_kernel_module_encrypt = /lib/modules/$(KERNEL_VERSION)/extra/encrypt

DESCRIPTION_kernel_module_frontcontroller = frontcontroller driver for control  devices
#RDEPENDS_kernel_module_frontcontroller = fp_control
FILES_kernel_module_frontcontroller = /lib/modules/$(KERNEL_VERSION)/extra/frontcontroller

DESCRIPTION_kernel_module_frontends = frontends driver for control  devices
FILES_kernel_module_frontends = /lib/modules/$(KERNEL_VERSION)/extra/frontends

DESCRIPTION_kernel_module_multicom = stm-multicom driver for control  devices
RDEPENDS_kernel_module_multicom = libmme-host libmmeimage
FILES_kernel_module_multicom = /lib/modules/$(KERNEL_VERSION)/extra/multicom

DESCRIPTION_kernel_module_player2 = frontends driver for control  devices
RDEPENDS_kernel_module_player2 = libmmeimage
FILES_kernel_module_player2 = /lib/modules/$(KERNEL_VERSION)/extra/player2

DESCRIPTION_kernel_module_pti = open source st-pti kernel module
RCONFLICTS_kernel_module_pti = kernel_module_ptinp
FILES_kernel_module_pti = /lib/modules/$(KERNEL_VERSION)/extra/pti

DESCRIPTION_kernel_module_ptinp = pti non public
RCONFLICTS_kernel_module_ptinp = kernel_module_pti
FILES_kernel_module_ptinp = lib/modules/$(KERNEL_VERSION)/extra/pti_np

DESCRIPTION_kernel_module_simu_button = simu-button driver for control  devices
FILES_kernel_module_simu_button = /lib/modules/$(KERNEL_VERSION)/extra/simu_button

DESCRIPTION_kernel_module_smartcard = smartcard driver for control  devices
FILES_kernel_module_smartcard = /lib/modules/$(KERNEL_VERSION)/extra/smartcard

DESCRIPTION_kernel_module_stgfb = stgfb driver for control  devices
#RDEPENDS_kernel_module_stgfb = stfbcontrol
FILES_kernel_module_stgfb = /lib/modules/$(KERNEL_VERSION)/extra/stgfb

DESCRIPTION_kernel_module_rt2870sta = rt2870sta frontends driver for control wireless devices
FILES_kernel_module_rt2870sta = /lib/modules/$(KERNEL_VERSION)/extra/wireless/rt2870sta
RDEPENDS_kernel_module_rt2870sta = firmware_rt2870

DESCRIPTION_kernel_module_rt3070sta = rt3070sta driver for control wireless devices
FILES_kernel_module_rt3070sta = /lib/modules/$(KERNEL_VERSION)/extra/wireless/rt3070sta
RDEPENDS_kernel_module_rt3070sta = firmware_rt3070

DESCRIPTION_kernel_module_rt5370sta = rt5370sta driver for control wireless devices
FILES_kernel_module_rt5370sta = /lib/modules/$(KERNEL_VERSION)/extra/wireless/rt5370sta
RDEPENDS_kernel_module_rt5370sta = firmware_rt5370

DESCRIPTION_kernel_module_rtl8192cu = rtl8192cu driver for control wireless devices
FILES_kernel_module_rtl8192cu = /lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8192cu
RDEPENDS_kernel_module_rtl8192cu = firmware_rtl8192cu

DESCRIPTION_kernel_module_rtl871x = rtl871x driver for control wifi devices
FILES_kernel_module_rtl871x = /lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl871x
RDEPENDS_kernel_module_rtl871x = firmware_rtl8712u

DESCRIPTION_kernel_module_rtl8188eu = rtl8188eu driver for control wifi  devices
FILES_kernel_module_rtl8188eu = /lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8188eu
RDEPENDS_kernel_module_rtl8188eu = firmware_rtl8188eu

call[[ ipkbox ]]

]]package


package[[ target_driver_headers

call[[ target_driver_common ]]

BDEPENDS_${P} = $(target_filesystem)
PR_${P} = 1

call[[ base ]]
call[[ git ]]

$(TARGET_${P}).do_package:
	$(PKDIR_clean)
	install -d $(PKDIR)/usr/include/linux/dvb

	cp $(driverdir)/stgfb/stmfb/linux/drivers/video/stmfb.h $(PKDIR)/usr/include/linux
	cp $(driverdir)/player2/linux/include/linux/dvb/stm_ioctls.h $(PKDIR)/usr/include/linux/dvb

	cp $(driverdir)/include/player2/JPEG_VideoTransformerTypes.h $(PKDIR)/usr/include/
	cp $(driverdir)/bpamem/bpamem.h $(PKDIR)/usr/include/
	touch $@

call[[ ipk ]]

]]package
