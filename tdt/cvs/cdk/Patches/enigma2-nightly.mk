# tuxbox/enigma2_pli
BEGIN[[
enigma2_pli
  git
  {PN}-nightly

ifdef ENABLE_E2D0
  git://github.com:schpuntik/enigma2-pli-arp.git;b=master;protocol=ssh
endif

ifdef ENABLE_E2D1
  git://github.com:schpuntik/enigma2-pli-arp.git;b=staging;protocol=ssh
endif

ifdef ENABLE_E2D2
  git://github.com:schpuntik/enigma2-pli-arp.git;b=last;protocol=ssh
endif

ifdef ENABLE_E2D3
    git://github.com/OpenAR-P/amiko-e2-pli.git;b=testing
endif

ifdef ENABLE_E2D4
  git://github.com/OpenAR-P/amiko-e2-pli.git;b=master
endif
;
]]END

DESCRIPTION_enigma2 := Framebuffer-based digital media application
PKGR_enigma2_pli = r3
SRC_URI_enigma2_pli := git://openpli.git.sourceforge.net/gitroot/openpli/enigma2
PACKAGES_enigma2_pli = 	enigma2 \
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

RDEPENDS_enigma2 = libgcc1 libpython2.7 python_threading libtuxtxt0 libungif4 libfreetype6 python_core python_twisted-core libdvbsi++1 python_re enigma2_fonts font_tuxtxt libpng16 font_valis_enigma libstdc++6 libglib libsigc_1.2 python_fcntl python_netclient python_netserver python_codecs libcrypto1 libfribidi0 python_zopeinterface python_xml libtuxtxt32bpp0 python_pickle libxmlccwrap python_shell ethtool libjpeg8 libdreamdvd0 python_twisted_web python_zlib python_crypt python_lang python_subprocess libeplayer3

PACKAGE_ARCH_enigma2 = $(box_arch)
FILES_enigma2 := /usr/bin \
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
FILES_enigma2_fonts = /usr/share/fonts/ae_AlMateen.ttf \
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


# Select enigma2 keymap.xml
enigma2_keymap_file = keymap$(if $(HL101),_$(HL101))$(if $(SPARK)$(SPARK7162),_spark).xml

E_CONFIG_OPTS =

ifdef ENABLE_EXTERNALLCD
E_CONFIG_OPTS += --with-graphlcd
endif

ifdef ENABLE_MEDIAFWGSTREAMER
E_CONFIG_OPTS += --enable-mediafwgstreamer
else
E_CONFIG_OPTS += --enable-libeplayer3 LIBEPLAYER3_CPPFLAGS="-I$(appsdir)/misc/tools/libeplayer3/include"
endif

ifdef ENABLE_SPARK
E_CONFIG_OPTS += --enable-spark
endif

ifdef ENABLE_SPARK7162
E_CONFIG_OPTS += --enable-spark7162
endif

$(DEPDIR)/enigma2-nightly.do_prepare: $(DEPENDS_enigma2_pli)
	$(PREPARE_enigma2_pli)
	touch $@

$(DIR_enigma2_pli)/config.status: bootstrap opkg ethtool freetype expat fontconfig libpng libjpeg libungif libgif libmme_host libmmeimage libfribidi libid3tag libmad libsigc libreadline \
		enigma2-nightly.do_prepare \
		libdvbsipp libxml2 zopeinterface twisted pycrypto pyusb pylimaging pyopenssl libaio pythonwifi libxmlccwrap \
		ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 $(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(DIR_enigma2_pli) && \
		$(BUILDENV) \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/share \
			--libdir=/usr/lib \
			--bindir=/usr/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-boxtype=none \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS) $(E_CONFIG_OPTS)


$(DEPDIR)/enigma2-nightly.do_compile: $(DIR_enigma2_pli)/config.status
	cd $(DIR_enigma2_pli) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-nightly: enigma2-nightly.do_compile
	$(call parent_pk,enigma2_pli)
	$(start_build)
	$(get_git_version)
	cd $(DIR_enigma2_pli) && \
		$(MAKE) install DESTDIR=$(PKDIR)
	$(target)-strip $(PKDIR)/usr/bin/enigma2
	cp -f $(buildprefix)/root/usr/local/share/enigma2/$(enigma2_keymap_file) $(PKDIR)/usr/share/enigma2/keymap.xml
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_amiko.xml $(PKDIR)/usr/share/enigma2/
	$(tocdk_build)
	$(toflash_build)
	touch $@

enigma2-nightly-clean:
	rm -f $(DEPDIR)/enigma2-nightly.do_compile
	cd $(DIR_enigma2_pli) && $(MAKE) clean

enigma2-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-nightly
	rm -f $(DEPDIR)/enigma2-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-nightly.do_prepare
	rm -rf $(DIR_enigma2_pli)
