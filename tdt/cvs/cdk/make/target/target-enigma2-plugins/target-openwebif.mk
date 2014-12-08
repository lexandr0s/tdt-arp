#
# AR-P buildsystem smart Makefile
#
package[[ target_openwebif

BDEPENDS_${P} = $(target_python_setuptools) $(target_aio_grab) $(target_python_cheetah)

PV_${P} = git
PR_${P} = 2

call[[ base ]]

rule[[
  nothing:git://github.com/OpenAR-P/e2openplugin-OpenWebif.git
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions && \
		cp -a plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif && \
	set -e; \
	for f in $$(find $(DIR_${P})/locale -name *.po ); do  \
	l=$$(echo $${f%} | sed 's/\.po//' | sed 's/.*locale\///'); \
	mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/$${l%}/LC_MESSAGES; \
	msgfmt -o $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/$${l%}/LC_MESSAGES/OpenWebif.mo ./locale/$$l.po; \
	done
	touch $@

call[[ ipk ]]

NAME_${P} = enigma2-plugin-extensions-openwebif
DESCRIPTION_${P} = open webinteface plugin for enigma2 by openpli team
RDEPENDS_${P} = python_cheetah aio_grab python_pyopenssl python_json python_serviceidentity
FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/OpenWebif

call[[ ipkbox ]]

]]package
