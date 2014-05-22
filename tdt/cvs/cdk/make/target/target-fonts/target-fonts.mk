#
# AR-P buildsystem smart Makefile
#
package[[ target_fonts

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 2
PACKAGE_ARCH_${P} = all

DESCRIPTION_${P} = fonts

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/usr/share/fonts
  install:-d:$(PKDIR)/usr/local
  install_file:$(PKDIR)/usr/share/fonts:file://ae_AlMateen.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://allruk.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://allruf.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://allru.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://blue.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://DejaVuLGCSans-Bold.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://ds_digital.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://FreeSans.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://goodtime.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://lcd.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://md_khmurabi_10.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://nmsbd.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://seg_internat.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://seg.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://Symbols.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://tuxtxt.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://uhr-digital.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://valis_enigma.ttf
  install_file:$(PKDIR)/usr/share/fonts:file://valis_lcd.ttf
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})

	ln -sf ../share/ $(PKDIR)/usr/local

	touch $@

PACKAGES_${P} = \
	font_ae_almateen \
	font_allruk \
	font_blue \
	font_ds_digital \
	font_goodtime \
	font_md_khmurabi \
	font_seg_internat \
	font_symbols \
	font_uhr_digital \
	font_valis_lcd \
	font_allruf \
	font_allru \
	font_dejavulgcsans_bold \
	font_freesans \
	font_lcd \
	font_nmsbd \
	font_seg \
	font_tuxtxt \
	font_valis_enigma

FILES_font_ae_almateen = /usr/share/fonts/ae_AlMateen.ttf
FILES_font_allruk = /usr/share/fonts/allruk.ttf
FILES_font_blue = /usr/share/fonts/blue.ttf
FILES_font_ds_digital = /usr/share/fonts/ds_digital.ttf
FILES_font_goodtime = /usr/share/fonts/goodtime.ttf
FILES_font_md_khmurabi = /usr/share/fonts/md_khmurabi_10.ttf
FILES_font_seg_internat = /usr/share/fonts/seg_internat.ttf
FILES_font_symbols = /usr/share/fonts/Symbols.ttf
FILES_font_uhr_digital = /usr/share/fonts/uhr-digital.ttf
FILES_font_valis_lcd = /usr/share/fonts/valis_lcd.ttf
FILES_font_allruf = /usr/share/fonts/allruf.ttf
FILES_font_allru = /usr/share/fonts/allru.ttf
FILES_font_dejavulgcsans_bold = /usr/share/fonts/DejaVuLGCSans-Bold.ttf
FILES_font_freesans = /usr/share/fonts/FreeSans.ttf
FILES_font_lcd = /usr/share/fonts/lcd.ttf
FILES_font_nmsbd = /usr/share/fonts/nmsbd.ttf
FILES_font_seg = /usr/share/fonts/seg.ttf
FILES_font_tuxtxt = /usr/share/fonts/tuxtxt.ttf
FILES_font_valis_enigma = /usr/share/fonts/valis_enigma.ttf

call[[ ipkbox ]]

]]package
