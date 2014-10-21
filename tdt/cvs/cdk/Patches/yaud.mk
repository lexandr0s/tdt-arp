#
# BOOTSTRAP
#
$(DEPDIR)/bootstrap: \
		build.env \
		libtool \
		$(FILESYSTEM) \
		$(GLIBC) \
		$(CROSS_LIBGCC) \
		$(LIBSTDC)

	@[ "x$*" = "x" ] && touch -r RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm $@ || true

#
# BARE-OS
#
bare-os: \
		bootstrap \
		$(LIBTERMCAP) \
		$(NCURSES_BASE) \
		$(NCURSES) \
		$(BASE_PASSWD) \
		$(MAKEDEV) \
		$(BASE_FILES) \
		opkghost \
		busybox \
		libz \
		bzip2 \
		$(INITSCRIPTS) \
		$(NETBASE) \
		$(BC) \
		$(SYSVINIT) \
		$(DISTRIBUTIONUTILS) \
		e2fsprogs \
		u-boot-utils

net-utils: \
		$(NETKIT_FTP) \
		portmap \
		$(NFSSERVER) \
		vsftpd \
		ethtool \
		openssl \
		openssl-dev \
		opkg \
		$(CIFS)

disk-utils: \
		$(XFSPROGS) \
		util-linux \
		jfsutils \
		$(SG3)
3g-utils: \
		usb_modeswitch \
		pppd \
		iptables \
		modem-scripts \
#
# YAUD
#

yaud-vdr: yaud-none \
		stslave \
		lirc \
		bootelf \
		vdr \
		release_vdr

yaud-neutrino-hd-nightly: yaud-none \
		lirc \
		stslave \
		bootelf \
		neutrino-hd-nightly \
		release_neutrino

yaud-enigma2-nightly-base: yaud-none \
		host_python \
		lirc \
		bootelf \
		initscripts \
		enigma2-nightly

yaud-enigma2-nightly: yaud-enigma2-nightly-base

yaud-enigma2-nightly-full: yaud-enigma2-nightly-base min-extras

yaud-xbmc-nightly: yaud-none host_python bootelf xbmc-nightly initscripts-xbmc release_xbmc

yaud-none: \
		bare-os \
		default_confs \
		libdvdcss \
		libdvdread \
		libdvdnav \
		linux-kernel \
		net-utils \
		disk-utils \
		driver \
		udev \
		udevrules \
		fp_control \
		evremote2 \
		devinit \
		ustslave \
		stfbcontrol \
		showiframe
#
# EXTRAS
#
min-extras: \
	ntfs3g \
	enigma2-plugins \
	wireless_tools \
	modem_scripts \
	enigma2-plugins-sh4
	
all-extras: \
	min-extras \
	oscamconfig \
	graphlcd \
	djmount \
	minidlna \
	brofs \
	tor \
	transmission \
	smbnetfs \
	samba \
	xupnpd \
	wireless_tools \
	enigma2-skins-sh4 \
	udpxy

#
# FLASH IMAGE
#

flash-enigma2-nightly:
	echo "Create image"
	$(if $(SPARK)$(SPARK7162), \
	cd $(prefix)/../flash/spark && \
		echo -e "1\n1" | ./spark.sh \
	)