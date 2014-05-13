#
# ENIGMA2
#
package[[ target_enigma2

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib) $(target_libsigc) $(target_libdvbsipp) $(target_freetype) $(target_tuxtxt32bpp) $(target_libgif) $(target_libpng) $(target_libjpeg) $(target_libxmlccwrap) $(target_libfribidi) $(target_python) $(target_python_twisted) $(target_linux_kernel_headers) $(target_libmmeimage) $(target_libmme_host) $(target_libdreamdvd)

PV_${P} = git
PR_${P} = 4
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Framebuffer-based digital media application

CONFIG_FLAGS_${P} = \
	--with-libsdl=no \
	--datadir=/usr/share \
	--libdir=/usr/lib \
	--bindir=/usr/bin \
	--sysconfdir=/etc \
	PY_PATH=$(targetprefix)/usr \
	$(PLATFORM_CPPFLAGS)

# media framework
ifdef CONFIG_GSTREAMER
BDEPENDS_${P} += $(target_gstreamer)
CONFIG_FLAGS_${P} += --enable-mediafwgstreamer
endif
ifdef CONFIG_EPLAYER3
BDEPENDS_${P} += $(target_libeplayer3)
CONFIG_FLAGS_${P} += --enable-libeplayer3 LIBEPLAYER3_CPPFLAGS="-I$(appsdir)/misc/tools/libeplayer3/include"
endif

# box type
ifdef CONFIG_SPARK
CONFIG_FLAGS_${P} += --enable-spark
keymap_${P} = keymap_spark.xml
endif
ifdef CONFIG_SPARK7162
CONFIG_FLAGS_${P} += --enable-spark7162
keymap_${P} = keymap_spark.xml
endif
ifdef CONFIG_HL101
CONFIG_FLAGS_${P} += --enable-hl101
keymap_${P} = keymap_hl101.xml
endif

# ???? lcd
ifdef CONFIG_EXTERNALLCD
CONFIG_FLAGS_${P} += --with-graphlcd
endif

call[[ base ]]

rule[[

ifdef CONFIG_ENIGMA2_SRC_MASTER
  git://github.com:schpuntik/enigma2-pli-arp.git;b=master;protocol=ssh
endif
ifdef CONFIG_ENIGMA2_SRC_STAGING
  git://github.com:schpuntik/enigma2-pli-arp.git;b=staging;protocol=ssh
endif
ifdef CONFIG_ENIGMA2_SRC_LAST
  git://github.com:schpuntik/enigma2-pli-arp.git;b=last;protocol=ssh
endif

  install:-d:$(PKDIR)/usr/share/enigma2/
  install_file:$(PKDIR)/usr/share/enigma2/keymap.xml:file://$(keymap_${P})
  install_file:$(PKDIR)/usr/share/enigma2/keymap_amiko.xml:file://keymap_amiko.xml

]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	cd $(DIR_${P}) && $(INSTALL_${P})

	$(target)-strip $(PKDIR)/usr/bin/enigma2
	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################

PACKAGES_${P} = \
	enigma2 \
	enigma2_meta \
	enigma2_fonts \
	font_valis_enigma \
	font_tuxtxt \
	enigma2_plugin_extensions_cutlisteditor \
	enigma2_plugin_extensions_dvdplayer \
	enigma2_plugin_extensions_graphmultiepg \
	enigma2_plugin_extensions_mediascanner \
	enigma2_plugin_extensions_mediaplayer \
	enigma2_plugin_extensions_modemsettings \
	enigma2_plugin_extensions_pictureplayer \
	enigma2_plugin_systemplugins_cablescan \
	enigma2_plugin_systemplugins_defaultservicesscanner \
	enigma2_plugin_systemplugins_diseqctester \
	enigma2_plugin_systemplugins_hdmicec \
	enigma2_plugin_systemplugins_hotplug \
	enigma2_plugin_systemplugins_keymapmanager \
	enigma2_plugin_systemplugins_networkwizard \
	enigma2_plugin_systemplugins_osd3dsetup \
	enigma2_plugin_systemplugins_osdpositionsetup \
	enigma2_plugin_systemplugins_positionersetup \
	enigma2_plugin_systemplugins_satelliteequipmentcontrol \
	enigma2_plugin_systemplugins_satfinder \
	enigma2_plugin_systemplugins_skinselector \
	enigma2_plugin_systemplugins_softwaremanager \
	enigma2_plugin_systemplugins_minivfd_icons \
	enigma2_plugin_systemplugins_videoclippingsetup \
	enigma2_plugin_systemplugins_videoenhancement \
	enigma2_plugin_systemplugins_videotune \
	enigma2_plugin_systemplugins_videomode \
	enigma2_plugin_systemplugins_wirelesslan \
	enigma2_plugin_skin_magic \
	enigma2_plugin_skin_megamod

RDEPENDS_enigma2 = libgcc1 libpython2.7 python-threading libtuxtxt0 libgif4 libfreetype6 python-core python-twisted-core libdvbsi++1 python-re enigma2-fonts font-tuxtxt libpng16 font-valis-enigma libstdc++6 libglib libsigc-1.2 python-fcntl python-netclient python-netserver python-codecs libcrypto1 libfribidi0 python-zopeinterface python-xml libtuxtxt32bpp0 python-pickle libxmlccwrap python-shell ethtool libjpeg8 libdreamdvd0 python-twisted-web python-zlib python-crypt python-lang python-subprocess libeplayer3
FILES_enigma2 = \
	/usr/bin \
	/usr/lib/libopen.* \
	/usr/lib/enigma2/python/Components \
	/usr/lib/enigma2/python/Plugins/Extensions/__init__.p* \
	/usr/lib/enigma2/python/Plugins/PLi/__init__.p* \
	/usr/lib/enigma2/python/Plugins/SystemPlugins/__init__.p* \
	/usr/lib/enigma2/python/Plugins/*.p* \
	/usr/lib/enigma2/python/Screens \
	/usr/lib/enigma2/python/Tools \
	/usr/lib/enigma2/python/*.p* \
	/usr/share/enigma2/countries \
	/usr/share/enigma2/extensions \
	/usr/share/enigma2/po \
	/usr/share/enigma2/rc_models \
	/usr/share/enigma2/skin_default \
	/usr/share/enigma2/*.* \
	/usr/share/keymaps

DESCRIPTION_enigma2_meta = meta files for  enigma2
RDEPENDS_enigma2_meta = enigma2
FILES_enigma2_meta = /usr/share/meta

DESCRIPTION_enigma2_fonts = Fonts for  enigma2
RDEPENDS_enigma2_fonts = enigma2
FILES_enigma2_fonts = \
	/usr/share/fonts/ae_AlMateen.ttf \
	/usr/share/fonts/andale.ttf \
	/usr/share/fonts/lcd.ttf \
	/usr/share/fonts/md_khmurabi_10.ttf \
	/usr/share/fonts/nmsbd.ttf

DESCRIPTION_font_valis_enigma = Fonts for  enigma2
RDEPENDS_font_valis_enigma = enigma2
FILES_font_valis_enigma = /usr/share/fonts/valis_enigma.ttf

DESCRIPTION_font_tuxtxt = Fonts for  enigma2
RDEPENDS_font_tuxtxt = enigma2
FILES_font_tuxtxt = /usr/share/fonts/tuxtxt.ttf

DESCRIPTION_enigma2_plugin_extensions_cutlisteditor = CutListEditor allows you to edit your movies
RDEPENDS_enigma2_plugin_extensions_cutlisteditor = enigma2
FILES_enigma2_plugin_extensions_cutlisteditor = /usr/lib/enigma2/python/Plugins/Extensions/CutListEditor

DESCRIPTION_enigma2_plugin_extensions_dvdplayer = DVDPlayer play you DVD disk's on  extern DVD device
RDEPENDS_enigma2_plugin_extensions_dvdplayer = enigma2
FILES_enigma2_plugin_extensions_dvdplayer = /usr/lib/enigma2/python/Plugins/Extensions/DVDPlayer

DESCRIPTION_enigma2_plugin_extensions_graphmultiepg =  GraphMultiEPG shows a graphical timeline EPG. \
Shows a nice overview of all running und upcoming tv shows.
RDEPENDS_enigma2_plugin_extensions_graphmultiepg = enigma2
FILES_enigma2_plugin_extensions_graphmultiepg = /usr/lib/enigma2/python/Plugins/Extensions/GraphMultiEPG

DESCRIPTION_enigma2_plugin_extensions_mediaplayer = Mediaplayer plays your favorite music and videos.\
Play all your favorite music and video files, organize them in playlists, view cover and album information.
RDEPENDS_enigma2_plugin_extensions_mediaplayer = enigma2
FILES_enigma2_plugin_extensions_mediaplayer = /usr/lib/enigma2/python/Plugins/Extensions/MediaPlayer

DESCRIPTION_enigma2_plugin_extensions_mediascanner = MediaScanner scans devices for playable media files \
and displays a menu with possible actions like viewing pictures or playing movies.
RDEPENDS_enigma2_plugin_extensions_mediascanner = enigma2
FILES_enigma2_plugin_extensions_mediascanner = /usr/lib/enigma2/python/Plugins/Extensions/MediaScanner

DESCRIPTION_enigma2_plugin_extensions_modemsettings = Tool to connect 3G modems
RDEPENDS_enigma2_plugin_extensions_modemsettings = enigma2
FILES_enigma2_plugin_extensions_modemsettings = /usr/lib/enigma2/python/Plugins/Extensions/ModemSettings

DESCRIPTION_enigma2_plugin_extensions_pictureplayer = The PicturePlayer displays your photos on the TV.\
nYou can view them as thumbnails or slideshow.
RDEPENDS_enigma2_plugin_extensions_pictureplayer = enigma2
FILES_enigma2_plugin_extensions_pictureplayer = /usr/lib/enigma2/python/Plugins/Extensions/PicturePlayer

DESCRIPTION_enigma2_plugin_extensions_socketmmi = Frontend for /tmp/mmi.socket Python frontend for /tmp/mmi.socket.
RDEPENDS_enigma2_plugin_extensions_socketmmi = enigma2
FILES_enigma2_plugin_extensions_socketmmi = /usr/lib/enigma2/python/Plugins/Extensions/SocketMMI

DESCRIPTION_enigma2_plugin_systemplugins_cablescan = Tool to  scan DVB-C
RDEPENDS_enigma2_plugin_systemplugins_cablescan = enigma2
FILES_enigma2_plugin_systemplugins_cablescan = /usr/lib/enigma2/python/Plugins/SystemPlugins/CableScan

DESCRIPTION_enigma2_plugin_systemplugins_defaultservicesscanner = With the DefaultServicesScanner plugin you can \
scan default lamedbs sorted by satellite with a connected dish positioner.
RDEPENDS_enigma2_plugin_systemplugins_defaultservicesscanner = enigma2
FILES_enigma2_plugin_systemplugins_defaultservicesscanner = /usr/lib/enigma2/python/Plugins/SystemPlugins/DefaultServicesScanner

DESCRIPTION_enigma2_plugin_systemplugins_diseqctester = With the DiseqcTester plugin you can test your satellite equipment for DiSEqC compatibility and errors.
RDEPENDS_enigma2_plugin_systemplugins_diseqctester = enigma2
FILES_enigma2_plugin_systemplugins_diseqctester = /usr/lib/enigma2/python/Plugins/SystemPlugins/DiseqcTester

DESCRIPTION_enigma2_plugin_systemplugins_fastscan = Tool to  scan  Providers
RDEPENDS_enigma2_plugin_systemplugins_fastscan = enigma2
FILES_enigma2_plugin_systemplugins_fastscan = /usr/lib/enigma2/python/Plugins/SystemPlugins/FastScan

DESCRIPTION_enigma2_plugin_systemplugins_hdmicec = The CEC allows HDMI devices to control each other when necessary and allows the user to operate multiple devices
RDEPENDS_enigma2_plugin_systemplugins_hdmicec = enigma2
FILES_enigma2_plugin_systemplugins_hdmicec = /usr/lib/enigma2/python/Plugins/SystemPlugins/HdmiCEC

DESCRIPTION_enigma2_plugin_systemplugins_hotplug = Hotplugging for removeable devices The Hotplug plugin notifies your system of newly added or removed devices.
RDEPENDS_enigma2_plugin_systemplugins_hotplug = enigma2
FILES_enigma2_plugin_systemplugins_hotplug = /usr/lib/enigma2/python/Plugins/SystemPlugins/Hotplug

DESCRIPTION_enigma2_plugin_systemplugins_keymapmanager = The KeymapManager plugin setup for optional keymaps.
RDEPENDS_enigma2_plugin_systemplugins_keymapmanager = enigma2
FILES_enigma2_plugin_systemplugins_keymapmanager = /usr/lib/enigma2/python/Plugins/SystemPlugins/KeymapManager \
	$(buildprefix)/root/usr/local/share/enigma2/keymap_amiko.xml

DESCRIPTION_enigma2_plugin_systemplugins_networkwizard = With the network wizard you can easily configure your network step by step.
RDEPENDS_enigma2_plugin_systemplugins_networkwizard = enigma2
FILES_enigma2_plugin_systemplugins_networkwizard = /usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkWizard

DESCRIPTION_enigma2_plugin_systemplugins_osd3dsetup = 3D  OSD setup
RDEPENDS_enigma2_plugin_systemplugins_osd3dsetup = enigma2
FILES_enigma2_plugin_systemplugins_osd3dsetup = /usr/lib/enigma2/python/Plugins/SystemPlugins/OSD3DSetup

DESCRIPTION_enigma2_plugin_systemplugins_osdpositionsetup = Compensate for overscan
RDEPENDS_enigma2_plugin_systemplugins_osdpositionsetup = enigma2
FILES_enigma2_plugin_systemplugins_osdpositionsetup = /usr/lib/enigma2/python/Plugins/SystemPlugins/OSDPositionSetup

DESCRIPTION_enigma2_plugin_systemplugins_positionersetup = With the PositionerSetup plugin it is easy to install and configure a motorized dish.
RDEPENDS_enigma2_plugin_systemplugins_positionersetup = enigma2
FILES_enigma2_plugin_systemplugins_positionersetup = /usr/lib/enigma2/python/Plugins/SystemPlugins/PositionerSetup

DESCRIPTION_enigma2_plugin_systemplugins_satelliteequipmentcontrol = With the SatelliteEquipmentControl plugin it is possible to fine-tune DiSEqC-settings.
RDEPENDS_enigma2_plugin_systemplugins_satelliteequipmentcontrol = enigma2
FILES_enigma2_plugin_systemplugins_satelliteequipmentcontrol = /usr/lib/enigma2/python/Plugins/SystemPlugins/SatelliteEquipmentControl

DESCRIPTION_enigma2_plugin_systemplugins_satfinder = The Satfinder plugin helps you to align your dish. It shows you informations about signal rate and errors.
RDEPENDS_enigma2_plugin_systemplugins_satfinder = enigma2
FILES_enigma2_plugin_systemplugins_satfinder = /usr/lib/enigma2/python/Plugins/SystemPlugins/Satfinder

DESCRIPTION_enigma2_plugin_systemplugins_skinselector = The SkinSelector shows a menu with selectable skins.\
It's now easy to change the look and feel of your receiver.
RDEPENDS_enigma2_plugin_systemplugins_skinselector = enigma2
FILES_enigma2_plugin_systemplugins_skinselector = /usr/lib/enigma2/python/Plugins/SystemPlugins/SkinSelector

DESCRIPTION_enigma2_plugin_systemplugins_softwaremanager = The software manager manages your receiver's software.\
It's easy to update your receiver's software, install or remove plugins or even backup and restore your system settings.
RDEPENDS_enigma2_plugin_systemplugins_softwaremanager = enigma2
FILES_enigma2_plugin_systemplugins_softwaremanager = /usr/lib/enigma2/python/Plugins/SystemPlugins/SoftwareManager

DESCRIPTION_enigma2_plugin_systemplugins_minivfd_icons = Minimal versoion VFD Icons plugin
RDEPENDS_enigma2_plugin_systemplugins_minivfd_icons = enigma2
RCONFLICTS_enigma2_plugin_systemplugins_minivfd_icons = enigma2_plugin_systemplugins_vfd_icons
FILES_enigma2_plugin_systemplugins_minivfd_icons = /usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons

DESCRIPTION_enigma2_plugin_systemplugins_videoclippingsetup = clip overscan / letterbox borders
RDEPENDS_enigma2_plugin_systemplugins_videoclippingsetup = enigma2
FILES_enigma2_plugin_systemplugins_videoclippingsetup = /usr/lib/enigma2/python/Plugins/SystemPlugins/VideoClippingSetup

DESCRIPTION_enigma2_plugin_systemplugins_videoenhancement = The VideoEnhancement plugin provides advanced video enhancement settings.
RDEPENDS_enigma2_plugin_systemplugins_videoenhancement = enigma2
FILES_enigma2_plugin_systemplugins_videoenhancement = /usr/lib/enigma2/python/Plugins/SystemPlugins/VideoEnhancement

DESCRIPTION_enigma2_plugin_systemplugins_videotune = The VideoTune helps fine-tuning your tv display.You can control brightness and contrast of your tv.
RDEPENDS_enigma2_plugin_systemplugins_videotune = enigma2
FILES_enigma2_plugin_systemplugins_videotune = /usr/lib/enigma2/python/Plugins/SystemPlugins/VideoTune

DESCRIPTION_enigma2_plugin_systemplugins_videomode = The Videomode plugin provides advanced video mode settings.
RDEPENDS_enigma2_plugin_systemplugins_videomode = enigma2
FILES_enigma2_plugin_systemplugins_videomode = /usr/lib/enigma2/python/Plugins/SystemPlugins/Videomode

DESCRIPTION_enigma2_plugin_systemplugins_wirelesslan = The wireless lan plugin helps you configuring your WLAN network interface.
RDEPENDS_enigma2_plugin_systemplugins_wirelesslan = enigma2 python_wifi
FILES_enigma2_plugin_systemplugins_wirelesslan = /usr/lib/enigma2/python/Plugins/SystemPlugins/WirelessLan

DESCRIPTION_enigma2_plugin_skin_magic = Skin Magic for SD video
RDEPENDS_enigma2_plugin_skin_magic = enigma2
FILES_enigma2_plugin_skin_magic = /usr/share/enigma2/Magic

DESCRIPTION_enigma2_plugin_skin_megamod = Skin megaMod  for HD video
RDEPENDS_enigma2_plugin_skin_megamod = enigma2 enigma2_plugin_systemplugins_libgisclubskin
FILES_enigma2_plugin_skin_megamod = /usr/share/enigma2/megaMod

call[[ ipkbox ]]

]]package