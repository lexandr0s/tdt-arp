#
# Plugins
#
$(DEPDIR)/enigma2-plugins: vfdicons mediaportal networkbrowser openwebif# openpli-plugins

#
# enigma2-openwebif
#
BEGIN[[
openwebif
  git
  e2openplugin-OpenWebif
  nothing:git://github.com/OpenAR-P/e2openplugin-OpenWebif.git
  make:install:DESTDIR=PKDIR
;
]]END
NAME_openwebif = enigma2_plugin_extensions_openwebif
DESCRIPTION_openwebif = "open webinteface plugin for enigma2 by openpli team"
PKGR_openwebif = r1
RDEPENDS_openwebif =  python_cheetah aio_grab

$(DEPDIR)/openwebif.do_prepare: bootstrap pythoncheetah $(DEPENDS_openwebif)
	$(PREPARE_openwebif)
	touch $@

$(DEPDIR)/openwebif: \
$(DEPDIR)/%openwebif: $(DEPDIR)/openwebif.do_prepare
	$(start_build)
	cd $(DIR_openwebif) && \
		$(BUILDENV) \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions && \
		cp -a plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif && \
	$(toflash_build)
	touch $@

#
# VFD-Icons
#
BEGIN[[
vfdicons
  git
  VFD-Icons
  nothing:git://github.com/OpenAR-P/VFD-Icons.git:b=master
  make:install:DESTDIR=PKDIR
;
]]END

NAME_vfdicons = enigma2_plugin_systemplugins_vfd_icons
DESCRIPTION_vfdicons = "open VFD-icons plugin for enigma2 by openAR-P teamv full simbols for Alien²"
RCONFLICTS_vfdicons = enigma2_plugin_systemplugins_minivfd_icons
PKGR_vfdicons = r0
RDEPENDS_vfdicons = python_core

$(DEPDIR)/vfdicons.do_prepare: bootstrap $(DEPENDS_vfdicons)
	$(PREPARE_vfdicons)
	touch $@

$(DEPDIR)/vfdicons: $(DEPDIR)/vfdicons.do_prepare
	$(start_build)
	cd $(DIR_vfdicons) && \
		$(BUILDENV) \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins && \
		cp -a plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons && \
	$(toflash_build)
	touch $@

#
# enigma2-mediaportal
#
BEGIN[[
mediaportal
  git
  MediaPortal
  nothing:git://github.com/OpenAR-P/MediaPortal.git
  make:install:DESTDIR=PKDIR
;
]]END
NAME_mediaportal = enigma2_plugin_extensions_mediaportal
DESCRIPTION_mediaportal = "Enigma2 MediaPortal"
PKGR_mediaportal = r0
PKGV_mediaportal = 5.0.7
RDEPENDS_mediaportal = python_core python_mechanize

$(DEPDIR)/mediaportal.do_prepare: bootstrap python  mechanize $(DEPENDS_mediaportal)
	$(PREPARE_mediaportal)
	touch $@

$(DEPDIR)/mediaportal.do_compile: $(DEPDIR)/mediaportal.do_prepare
	cd $(DIR_mediaportal) && \
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

$(DEPDIR)/mediaportal: $(DEPDIR)/mediaportal.do_compile
	$(start_build)
	cd $(DIR_mediaportal) && \
		$(MAKE) install DESTDIR=$(PKDIR)
	$(toflash_build)
	touch $@
#
# enigma2-pli-networkbrowser
#
BEGIN[[
networkbrowser
  git
  {PN}-{PV}
  nothing:git://git.code.sf.net/p/openpli/plugins-enigma2:sub=networkbrowser
  patch:file://{PN}-support_autofs.patch
  make:install:DESTDIR=PKDIR
;
]]END
NAME_networkbrowser = enigma2_plugin_extensions_pli_networkbrowser
DESCRIPTION_networkbrowser = "networkbrowser plugin for enigma2"
PKGR_networkbrowser = r1

$(DEPDIR)/networkbrowser.do_prepare: $(DEPENDS_networkbrowser)
	$(PREPARE_networkbrowser)
	touch $@

$(DEPDIR)/networkbrowser: $(DEPDIR)/networkbrowser.do_prepare
	$(start_build)
	cd $(DIR_networkbrowser)/src/lib && \
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
	cd $(DIR_networkbrowser) && \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser && \
		cp -a po $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a meta $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/* $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/lib/netscan.so $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		rm -rf $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/lib
	$(toflash_build)
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
	$(toflash_build)
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