#
# Plugins
#
$(DEPDIR)/enigma2-plugins: enigma2_plugin_systemplugins_vfd_icons enigma2_plugin_extensions_mediaportal enigma2_networkbrowser openpli-plugins

#
# enigma2-openwebif
#
BEGIN[[
enigma2_plugin_extensions_openwebif
  git
  e2openplugin-OpenWebif
  nothing:git://github.com/OpenAR-P/e2openplugin-OpenWebif.git
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_enigma2_plugin_extensions_openwebif = "open webinteface plugin for enigma2 by openpli team"
PKGR_enigma2_plugin_extensions_openwebif = r1
RDEPENDS_enigma2_plugin_extensions_openwebif = python pythoncheetah grab

$(DEPDIR)/enigma2_plugin_extensions_openwebif.do_prepare: bootstrap $(RDEPENDS_enigma2_plugin_extensions_openwebif) $(DEPENDS_enigma2_plugin_extensions_openwebif)
	$(PREPARE_enigma2_plugin_extensions_openwebif)
	touch $@

$(DEPDIR)/enigma2_plugin_extensions_openwebif: \
$(DEPDIR)/%enigma2_plugin_extensions_openwebif: $(DEPDIR)/enigma2_plugin_extensions_openwebif.do_prepare
	$(start_build)
	cd $(DIR_enigma2_plugin_extensions_openwebif) && \
		$(BUILDENV) \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions && \
		cp -a plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif && \
	$(e2extra_build)
	touch $@

#
# VFD-Icons
#
BEGIN[[
enigma2_plugin_systemplugins_vfd_icons
  git
  VFD-Icons
  nothing:git://github.com/OpenAR-P/VFD-Icons.git:b=master
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_enigma2_plugin_systemplugins_vfd_icons = "open VFD-icons plugin for enigma2 by openAR-P team"
PKGR_enigma2_plugin_systemplugins_vfd_icons = r0
RDEPENDS_enigma2_plugin_systemplugins_vfd_icons = python

$(DEPDIR)/enigma2_plugin_systemplugins_vfd_icons.do_prepare: bootstrap $(RDEPENDS_enigma2_plugin_systemplugins_vfd_icons) $(DEPENDS_enigma2_plugin_systemplugins_vfd_icons)
	$(PREPARE_enigma2_plugin_systemplugins_vfd_icons)
	touch $@

$(DEPDIR)/enigma2_plugin_systemplugins_vfd_icons: \
$(DEPDIR)/%enigma2_plugin_systemplugins_vfd_icons: $(DEPDIR)/enigma2_plugin_systemplugins_vfd_icons.do_prepare
	$(start_build)
	cd $(DIR_enigma2_plugin_systemplugins_vfd_icons) && \
		$(BUILDENV) \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins && \
		cp -a plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons && \
	$(toflash_build)
	touch $@

#
# enigma2-mediaportal
#
BEGIN[[
enigma2_plugin_extensions_mediaportal
  git
  MediaPortal
  nothing:git://github.com/OpenAR-P/MediaPortal.git
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_enigma2_plugin_extensions_mediaportal = "Enigma2 MediaPortal"
PKGR_enigma2_plugin_extensions_mediaportal = r0
RDEPENDS_enigma2_plugin_extensions_mediaportal = python mechanize

$(DEPDIR)/enigma2_plugin_extensions_mediaportal.do_prepare: bootstrap $(RDEPENDS_enigma2_plugin_extensions_mediaportal) $(DEPENDS_enigma2_plugin_extensions_mediaportal)
	$(PREPARE_enigma2_plugin_extensions_mediaportal)
	touch $@

$(DEPDIR)/enigma2_plugin_extensions_mediaportal.do_compile: $(DEPDIR)/enigma2_plugin_extensions_mediaportal.do_prepare
	cd $(DIR_enigma2_plugin_extensions_mediaportal) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--datadir=/usr/share \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)
	touch $@

$(DEPDIR)/enigma2_plugin_extensions_mediaportal: $(DEPDIR)/enigma2_plugin_extensions_mediaportal.do_compile
	$(start_build)
	cd $(DIR_enigma2_plugin_extensions_mediaportal) && \
		$(MAKE) install DESTDIR=$(PKDIR)
	$(toflash_build)
	touch $@
#
# enigma2-networkbrowser
#
BEGIN[[
enigma2_networkbrowser
  git
  {PN}-{PV}
  nothing:git://git.code.sf.net/p/openpli/plugins-enigma2:sub=networkbrowser
  patch:file://{PN}-support_autofs.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_enigma2_networkbrowser = "networkbrowser plugin for enigma2"
PKGR_enigma2_networkbrowser = r1

$(DEPDIR)/enigma2_networkbrowser.do_prepare: $(DEPENDS_enigma2_networkbrowser)
	$(PREPARE_enigma2_networkbrowser)
	touch $@

$(DEPDIR)/enigma2_networkbrowser: \
$(DEPDIR)/%enigma2_networkbrowser: $(DEPDIR)/enigma2_networkbrowser.do_prepare
	$(start_build)
	cd $(DIR_enigma2_networkbrowser)/src/lib && \
		$(BUILDENV) \
		sh4-linux-gcc -shared -o netscan.so \
			-I $(targetprefix)/usr/include/python$(PYTHON_VERSION) \
			-include Python.h \
			errors.h \
			list.c \
			list.h \
			main.c \
			nbtscan.c \
			nbtscan.h \
			range.c \
			range.h \
			showmount.c \
			showmount.h \
			smb.h \
			smbinfo.c \
			smbinfo.h \
			statusq.c \
			statusq.h \
			time_compat.h
	cd $(DIR_enigma2_networkbrowser) && \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser && \
		cp -a po $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a meta $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/* $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/lib/netscan.so $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		rm -rf $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/lib
	$(e2extra_build)
	touch $@

$(DEPDIR)/%-openpli:
	$(call git_fetch_prepare,$*_openpli,git://github.com/E2OpenPlugins/e2openplugin-$*.git)
	$(eval FILES_$*_openpli += /usr/lib/enigma2/python/Plugins)
	$(eval NAME_$*_openpli = enigma2-plugin-extensions-$*)
	$(start_build)
	$(get_git_version)
	cd $(DIR_$*_openpli) && \
		$(python) setup.py install --root=$(PKDIR) --install-lib=/usr/lib/enigma2/python/Plugins
	$(remove_pyc)
	$(e2extra_build)
	touch $@

DESCRIPTION_NewsReader_openpli = RSS reader
DESCRIPTION_AddStreamUrl_openpli = Add a stream url to your channellist
DESCRIPTION_Satscan_openpli = Alternative blind scan plugin for DVB-S
DESCRIPTION_SimpleUmount_openpli = list of mounted mass storage devices and umount one of them
PKGR_openpli_plugins = r1

openpli_plugin_list = \
AddStreamUrl \
NewsReader \
Satscan \
SimpleUmount

# openpli plugins that go to flash
openpli_plugin_distlist = \
SimpleUmount

openpli_plugin_list += $(openpli_plugin_distlist)

$(foreach p,$(openpli_plugin_distlist),$(eval DIST_$p_openpli = $p_openpli))

openpli-plugins: $(addprefix $(DEPDIR)/,$(addsuffix -openpli,$(openpli_plugin_list)))