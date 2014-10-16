#
# AR-P buildsystem smart Makefile
#
package[[ target_vfdicons

BDEPENDS_${P} = $(target_python)

PV_${P} = git
PR_${P} = 2

call[[ base ]]

rule[[
  nothing:git://github.com/OpenAR-P/VFD-Icons.git:b=master
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins
	cp -a $(DIR_${P})/plugin $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons
	touch $@

NAME_${P} = enigma2-plugin-systemplugins-vfd-icons
DESCRIPTION_${P} = open VFD-icons plugin for enigma2 by openAR-P team full simbols for Alien2
RDEPENDS_${P} = python_core
RCONFLICTS_${P} = enigma2-plugin-systemplugins-minivfd-icons
FILES_${P} = /usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons

call[[ ipkbox ]]

]]package
