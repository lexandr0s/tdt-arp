#
# AR-P buildsystem smart Makefile
#
package[[ target_firmware_wlan

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = all

DESCRIPTION_${P} = linux-firmware

call[[ base ]]

rule[[
  nothing:git://github.com/BjornLee/linux-firmware.git
  nothing:file://Wireless/RT2870STA/RT2870STA.dat
  nothing:file://Wireless/RT3070STA/RT3070STA.dat
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/ && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/rtl8188eu/ && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/rtlwifi/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/RT2870STA/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/RT3070STA/ && \
	$(INSTALL_FILE) RT2870STA.dat $(PKDIR)/etc/Wireless/RT2870STA/ && \
	$(INSTALL_FILE) rt2870.bin $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) RT3070STA.dat $(PKDIR)/etc/Wireless/RT3070STA/ && \
	ln -sf /lib/firmware/rt2870.bin $(PKDIR)/lib/firmware/rt3070.bin && \
	ln -sf /lib/firmware/rt2870.bin $(PKDIR)/lib/firmware/rt5370.bin && \
	$(INSTALL_FILE) $(driverdir)/wireless/rtl8188eu/rtl8188eufw.bin $(PKDIR)/lib/firmware/rtl8188eu && \
	$(INSTALL_FILE) rtlwifi/rtl8192cufw.bin $(PKDIR)/lib/firmware/rtlwifi && \
	$(INSTALL_FILE) rtlwifi/rtl8712u.bin $(PKDIR)/lib/firmware/rtlwifi
	touch $@

PACKAGES_${P} = \
	firmware_rt2870 \
	firmware_rt3070 \
	firmware_rt5370 \
	firmware_rtl8188eu \
	firmware_rtl8192cu \
	firmware_rtl8712u

FILES_firmware_rt2870 = \
	/lib/firmware/rt2870.bin \
	/etc/Wireless/RT2870STA/RT2870STA.dat

FILES_firmware_rt3070 = \
	/lib/firmware/rt3070.bin \
	/etc/Wireless/RT3070STA/RT3070STA.dat
RDEPENDS_firmware_rt3070 = \
	firmware_rt2870

FILES_firmware_rt5370 = \
	/lib/firmware/rt5370.bin \
RDEPENDS_firmware_rt5370 = \
	firmware_rt2870

FILES_firmware_rtl8188eu = \
	/lib/firmware/rtl8188eu/rtl8188eufw.bin

FILES_firmware_rtl8192cu =\
	/lib/firmware/rtlwifi/rtl8192cufw.bin

FILES_firmware_rtl8712u = \
	/lib/firmware/rtlwifi/rtl8712u.bin

call[[ ipkbox ]]

]]package
