#
# AR-P buildsystem smart Makefile
#
package[[ target_enigma2_skins_magic

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://git.code.sf.net/p/openpli/skin-magic
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && cp -a $(DIR_${P})/usr $(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = enigma2-plugin-skin-magic
DESCRIPTION_${P} = Skin Magic SD for enigma2
RDEPENDS_${P} = enigma2
FILES_${P} = /usr/share/enigma2/Magic

call[[ ipkbox ]]

]]package
