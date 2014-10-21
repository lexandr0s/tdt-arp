image: package-index
	rm -rf $(prefix)/release || true
	$(INSTALL_DIR) $(prefix)/release && \
	$(INSTALL_DIR) $(prefix)/release/usr/lib/opkg/ && \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export HHL_CROSS_TARGET_DIR=$(prefix)/release && \
	export OPKG_OFFLINE_ROOT=$(prefix)/release && \
	opkg update -f $(crossprefix)/etc/opkg.conf  -o $(prefix)/release && \
	opkg install $(opkg_system) $(opkg_os) $(opkg_enigma2) $(opkg_wireless) $(opkg_net_utils) -f $(crossprefix)/etc/opkg.conf -o $(prefix)/release --force-postinstall
# add version
	echo "version=OpenAR-P_`date +%d-%m-%y-%T`_git-`git rev-list --count HEAD`" > $(prefix)/release/etc/image-version
	echo ---------------------------------------------------------- >> $(prefix)/release/etc/image-version
	echo ---------------------------------------------------------- >> $(prefix)/release/etc/image-version
	cat $(buildprefix)/lastChoice |tr ' ' '\n'|grep enable >> $(prefix)/release/etc/image-version
	touch $@
#########################################################################################
##### install release over opkg packages##################
## section system
opkg_system := boot-elf \
	       filesystem \
	       firmware \
	       init-scripts \
	       bootlogo  \
	       update-rc.d \
	       base-files \
	       default-bins

opkg_os := linux-kernel \
		busybox \
		opkg \
		ntfs-3g \
		evremote2 \
		libdvdcss2 \
		libdvdread4 \
		libdvdnav4 \
		libtermcap \
		libz1 \
		libbz2 \
		e2fsprogs-mke2fs \
		e2fsprogs-e2fsck \
		util-linux-sfdisk \
		libncurses5 \
		libreadline6 \
		curl \
		mpc \
		mpfr \
		libgmpxx4 \
		sysvinit \
		showiframe \
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
		kernel-module-stgfb \
		distro-feed-configs \
		udev-rules \
		libeplayer3

opkg_enigma2 := enigma2 \
		config-satellites \
		config-cables \
		config-terrestrial \
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
		enigma2-plugin-systemplugins-wirelesslan \
		enigma2-plugin-skin-magic

opkg_enigma2_full := enigma2-plugin-skin-megamod \
		     enigma2-plugin-systemplugins-libgisclubskin

opkg_wireless := wireless-tools \
		kernel-module-rt2870sta \
		kernel-module-rt3070sta \
		kernel-module-rt5370sta \
		kernel-module-rtl8192cu \
		kernel-module-rtl871x \
		kernel-module-rtl8188eu

opkg_net_utils:= portmap \
		 vsftpd \
		 ethtool

opkg_3g := modem-scripts


# release_hl101:
#	echo "hl101" > $(prefix)/release/etc/hostname && \
#	cp -f $(buildprefix)/root/release/fstab_hl101 $(prefix)/release/etc/fstab
#	cp $(buildprefix)/root/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/ && \
#	cp $(buildprefix)/root/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/


# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
# $(DEPDIR)/release: $(DEPDIR)/%release:bootelf release_$(HL101)$(SPARK)$(SPARK7162)
# Post tweaks
#	$(DEPMOD) -b $(prefix)/release $(KERNELVERSION)
#8	touch $@

# release-clean:
#	rm -f $(DEPDIR)/release
#	rm -f $(DEPDIR)/release_$(HL101)$(SPARK)$(SPARK7162)
#	rm -f $(DEPDIR)/release_common_utils 

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma2 #############
#	cp -RP $(buildprefix)/own_build/enigma2/* $(prefix)/release/
