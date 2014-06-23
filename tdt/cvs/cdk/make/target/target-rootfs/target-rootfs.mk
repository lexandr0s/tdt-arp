#
# AR-P buildsystem smart Makefile
#
package[[ target_rootfs

IPKBOX_LIST_${P} = $(target_glibc) $(target_gcc) $(target_gcc_lib) $(target_base_files) $(target_driver) $(target_netbase) $(target_opkg) $(target_busybox) $(target_base_passwd) \
$(target_ustslave) $(target_sysvinit) $(target_devinit) $(target_udev) $(target_lirc) $(target_evremote2) $(target_vsftpd) $(target_ethtool) $(target_fonts) \
$(target_fp_control) $(target_stfbcontrol) $(target_libfribidi) $(target_showiframe) $(target_portmap) $(target_firmware) $(target_bootelf) $(target_util_linux) $(target_e2fsprogs) \
$(target_udev_rules) $(target_bootlogo) $(target_flash_tools) $(target_rfkill) $(target_distro_feed_configs) $(target_initscripts) $(target_update_rcd)

ifdef CONFIG_BUILD_ENIGMA2
IPKBOX_LIST_${P} += $(target_enigma2) $(target_tuxbox_configs) $(target_hotplug_e2_helper)
endif

ifdef CONFIG_BUILD_HYBRID
IPKBOX_LIST_${P} += $(target_enigma2) $(target_tuxbox_configs) $(target_hotplug_e2_helper) $(target_neutrino) $(target_libid3tag) $(target_libvorbisidec) $(target_libcap) $(target_libmad)
endif

ifdef CONFIG_ENIGMA2_PLUGINS
IPKBOX_LIST_${P} += $(target_enigma2_plugins) $(target_openwebif) $(target_mediaportal) $(target_aio_grab) $(target_python_cheetah) $(target_python_pyopenssl) $(target_python_pycrypto) $(target_python_wifi) \
$(target_python_mechanize)
endif

ifdef CONFIG_BUILD_NEUTRINO
IPKBOX_LIST_${P} += $(target_neutrino) $(target_libid3tag) $(target_libvorbisidec) $(target_libcap) $(target_libmad)
endif

ifdef CONFIG_WLAN_SUPPORT
IPKBOX_LIST_${P} += $(target_wireless_tools) $(target_firmware_wlan)
endif

ifdef CONFIG_3G_SUPPORT
IPKBOX_LIST_${P} += $(target_modem_scripts) $(target_usb_modeswitch) $(target_pppd)
endif

ifdef CONFIG_NTFS_3G_SUPPORT
IPKBOX_LIST_${P} += $(target_ntfs_3g)
endif

ifdef CONFIG_IPTABLES_SUPPORT
IPKBOX_LIST_${P} += $(target_iptables)
endif

DEPENDS_${P} = $(addsuffix .do_ipkbox, $(IPKBOX_LIST_${P}))

#########################################################################################

PV_${P} = 0.1
PR_${P} = 5

call[[ base ]]

WORK_${P} = $(prefix)/release
DIR_${P} = $(WORK_${P})
opkg_rootfs := opkg -f $(prefix)/opkg-box.conf -o $(DIR_${P})

$(TARGET_${P}): $(DEPENDS_${P})
	$(PREPARE_${P})
	( echo "dest root /"; \
	  echo "arch $(box_arch) 16"; \
	  echo "arch sh4 10"; \
	  echo "arch all 1"; \
	  echo "src/gz box file://$(ipkbox)"; \
	) > $(prefix)/opkg-box.conf

	cd $(ipkbox) && \
		/usr/bin/python $(hostprefix)/bin/ipkg-make-index . > Packages && \
		cat Packages | gzip > Packages.gz
	install -d $(DIR_${P})/usr/lib/opkg

	export OPKG_OFFLINE_ROOT=$(DIR_${P}) && \
	$(opkg_rootfs) update && \
	$(opkg_rootfs) install --force-postinstall $(opkg_my_list)

#		$(opkg_system) $(opkg_os) $(opkg_enigma2) $(opkg_wireless) $(opkg_net_utils)

# add version
	echo "version=OpenAR-P_`date +%d-%m-%y-%T`_git-`git rev-list --count HEAD`" > $(DIR_${P})/etc/image-version
	echo "----------------------------------------------------------" >>          $(DIR_${P})/etc/image-version
	echo "----------------------------------------------------------" >>          $(DIR_${P})/etc/image-version
	cat $(buildprefix)/.config |grep -v '^#' |tr ' ' '\n' >>                      $(DIR_${P})/etc/image-version
	touch $@

# core system libraries, binaries and scripts
opkg_my_list = \
	sysvinit \
	devinit \
	udev \
	udev-rules \
	initscripts \
	update-rc.d \
	busybox \
	base-passwd \
	base-files \
	netbase \
	opkg \
	libz1 \
	libc6 \
	libgcc1

# netutils binaries and tools
opkg_my_list += \
	portmap \
	vsftpd \
	ethtool

# kernel with firmware and modules
opkg_my_list += \
	boot-elf \
	bootlogo \
	firmware \
	ustslave \
	evremote2 \
	fp-control \
	stfbcontrol \
	showiframe \
	linux-kernel \
	kernel-module-avs \
	kernel-module-bpamem \
	kernel-module-cec \
	kernel-module-compcache \
	kernel-module-cpu-frequ \
	kernel-module-e2-proc \
	kernel-module-encrypt \
	kernel-module-frontcontroller \
	kernel-module-frontends \
	kernel-module-multicom \
	kernel-module-player2 \
	kernel-module-ptinp \
	kernel-module-simu-button \
	kernel-module-smartcard \
	kernel-module-stgfb
#########################################################################################
# enigma2
ifdef CONFIG_BUILD_ENIGMA2
opkg_my_list += \
	config-satellites \
	config-cables \
	config-terrestrial \
	config-timezone \
	hotplug-e2-helper \
	enigma2 \
	enigma2-plugin-extensions-cutlisteditor \
	enigma2-plugin-extensions-dvdplayer \
	enigma2-plugin-extensions-graphmultiepg \
	enigma2-plugin-extensions-mediascanner \
	enigma2-plugin-extensions-mediaplayer \
	enigma2-plugin-extensions-modemsettings \
	enigma2-plugin-extensions-pictureplayer \
	enigma2-plugin-systemplugins-cablescan \
	enigma2-plugin-systemplugins-defaultservicesscanner \
	enigma2-plugin-systemplugins-diseqctester \
	enigma2-plugin-systemplugins-hdmicec \
	enigma2-plugin-systemplugins-hotplug \
	enigma2-plugin-systemplugins-keymapmanager \
	enigma2-plugin-systemplugins-networkwizard \
	enigma2-plugin-systemplugins-osd3dsetup \
	enigma2-plugin-systemplugins-osdpositionsetup \
	enigma2-plugin-systemplugins-positionersetup \
	enigma2-plugin-systemplugins-satelliteequipmentcontrol \
	enigma2-plugin-systemplugins-satfinder \
	enigma2-plugin-systemplugins-skinselector \
	enigma2-plugin-systemplugins-softwaremanager \
	enigma2-plugin-systemplugins-minivfd-icons \
	enigma2-plugin-systemplugins-videoclippingsetup \
	enigma2-plugin-systemplugins-videoenhancement \
	enigma2-plugin-systemplugins-videotune \
	enigma2-plugin-systemplugins-videomode \
	enigma2-plugin-skin-magic
ifdef CONFIG_WLAN_SUPPORT
opkg_my_list += enigma2-plugin-systemplugins-wirelesslan
endif
endif

ifdef CONFIG_BUILD_HYBRID
opkg_my_list += \
	config-satellites \
	config-cables \
	config-terrestrial \
	config-timezone \
	hotplug-e2-helper \
	enigma2 \
	enigma2-plugin-extensions-cutlisteditor \
	enigma2-plugin-extensions-dvdplayer \
	enigma2-plugin-extensions-graphmultiepg \
	enigma2-plugin-extensions-mediascanner \
	enigma2-plugin-extensions-mediaplayer \
	enigma2-plugin-extensions-modemsettings \
	enigma2-plugin-extensions-pictureplayer \
	enigma2-plugin-systemplugins-cablescan \
	enigma2-plugin-systemplugins-defaultservicesscanner \
	enigma2-plugin-systemplugins-diseqctester \
	enigma2-plugin-systemplugins-hdmicec \
	enigma2-plugin-systemplugins-hotplug \
	enigma2-plugin-systemplugins-keymapmanager \
	enigma2-plugin-systemplugins-networkwizard \
	enigma2-plugin-systemplugins-osd3dsetup \
	enigma2-plugin-systemplugins-osdpositionsetup \
	enigma2-plugin-systemplugins-positionersetup \
	enigma2-plugin-systemplugins-satelliteequipmentcontrol \
	enigma2-plugin-systemplugins-satfinder \
	enigma2-plugin-systemplugins-skinselector \
	enigma2-plugin-systemplugins-softwaremanager \
	enigma2-plugin-systemplugins-minivfd-icons \
	enigma2-plugin-systemplugins-videoclippingsetup \
	enigma2-plugin-systemplugins-videoenhancement \
	enigma2-plugin-systemplugins-videotune \
	enigma2-plugin-systemplugins-videomode \
	enigma2-plugin-skin-magic
ifdef CONFIG_WLAN_SUPPORT
opkg_my_list += enigma2-plugin-systemplugins-wirelesslan
endif
endif

ifdef CONFIG_ENIGMA2_EXTENSION_OPENWEBIF
opkg_my_list += enigma2-plugin-extensions-openwebif
endif

ifdef CONFIG_ENIGMA2_EXTENSION_MEDIAPORTAL
opkg_my_list += enigma2-plugin-extensions-mediaportal
endif

ifdef CONFIG_ENIGMA2_SKIN_MEGAMOD
opkg_my_list += enigma2-plugin-skin-megamod
endif

ifdef CONFIG_ENIGMA2_EXTENSION_ALTSOFTCAM
opkg_my_list += enigma2-plugin-extensions-alternativesoftcammanager
endif

########################################################################################
#neutrino

ifdef CONFIG_BUILD_NEUTRINO
opkg_my_list += neutrino libblkid1
endif

ifdef CONFIG_BUILD_HYBRID
opkg_my_list += neutrino libblkid1
endif

########################################################################################
#extras

ifdef CONFIG_WLAN_SUPPORT
opkg_my_list += wireless-tools \
		kernel-module-rt2870sta \
		kernel-module-rt3070sta \
		kernel-module-rt5370sta \
		kernel-module-rtl8192cu \
		kernel-module-rtl871x \
		kernel-module-rtl8188eu
endif

ifdef CONFIG_3G_SUPPORT
opkg_my_list += modem-scripts
endif

ifdef CONFIG_NTFS_3G_SUPPORT
opkg_my_list += ntfs-3g
endif

ifdef CONFIG_IPTABLES_SUPPORT
opkg_my_list += iptables
endif

#########################################################################################

]]package
