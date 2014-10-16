#
# AR-P buildsystem smart Makefile
#
package[[ target_networkbrowser

BDEPENDS_${P} = $(target_python)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://git.code.sf.net/p/openpli/plugins-enigma2:sub=networkbrowser
  patch:file://${PN}-support_autofs.patch
]]rule

call[[ git ]]

CONFIG_FLAGS_${P} = \
	--datadir=/usr/share \
	--libdir=/usr/lib \
	--bindir=/usr/bin \
	--sysconfdir=/etc \
	PY_PATH=$(targetprefix)/usr \
	$(PLATFORM_CPPFLAGS)

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	cd $(DIR_${P})/src/lib && \
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
		cd $(DIR_${P}) && \
		mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a meta $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/* $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/lib/netscan.so $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		set -e; \
			for f in $$(find $(DIR_${P})/po -name *.po ); do  \
			l=$$(echo $${f%} | sed 's/\.po//' | sed 's/.*po\///'); \
			mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/locale/$${l%}/LC_MESSAGES; \
			msgfmt -o $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/locale/$${l%}/LC_MESSAGES/NetworkBrowser.mo ./po/$$l.po; \
		done
		find $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ -type f -name *.am -exec rm -f {} \;
		rm -rf $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/lib
	touch $@

NAME_${P} = enigma2-plugin-extensions-pli-networkbrowser
DESCRIPTION_${P} ="networkbrowser plugin for enigma2"
FILES_${P} = /usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/

call[[ ipkbox ]]

]]package
