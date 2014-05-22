#
# AR-P buildsystem smart Makefile
#
package[[ target_openwebif

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = git
PR_${P} = 1

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
		cp -a plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif
	touch $@

call[[ ipk ]]

NAME_${P} = enigma2-plugin-extensions-openwebif
DESCRIPTION_${P} = "open webinteface plugin for enigma2 by openpli team"
RDEPENDS_${P} = python_cheetah aio_grab
FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/OpenWebif

call[[ ipkbox ]]

]]package
