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