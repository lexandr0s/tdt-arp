#
# skin-PLiHD
#
BEGIN[[
e2skin_plihd
  git
  {PN}
  git://github.com/littlesat/skin-PLiHD.git:b=master
;
]]END

NAME_e2skin_plihd = enigma2_plugin_skin_plihd
DESCRIPTION_e2skin_plihd := Skin PLiHD for Enigma2
PKGR_e2skin_plihd = r2

$(DEPDIR)/e2skin-plihd.do_prepare: $(DEPENDS_e2skin_plihd)
	$(PREPARE_e2skin_plihd)
	touch $@

$(DEPDIR)/e2skin-plihd: e2skin-plihd.do_prepare
	$(start_build)
	cd $(DIR_e2skin_plihd) && \
		cp -a usr $(PKDIR)
	$(toflash_build)
	touch $@

e2skin-plihd-distclean:
	rm -f $(DEPDIR)/e2skin-plihd.do_prepare
	rm -rf $(DIR_e2skin_plihd)

#
# skin-dTV-HD-Reloaded
#
BEGIN[[
e2skin_dTVHDReloaded
  git
  {PN}
  git://github.com/Taapat/skin-dTV-HD-Reloaded.git:b=master
;
]]END

NAME_e2skin_dTVHDReloaded = enigma2_plugin_skin_dtvhdreloaded
DESCRIPTION_e2skin_dTVHDReloaded := SD skin dTV-HD-Reloaded from Taapat
PKGR_e2skin_dTVHDReloaded = r0

$(DEPDIR)/e2skin-dTVHDReloaded.do_prepare: $(DEPENDS_e2skin_dTVHDReloaded)
	$(PREPARE_e2skin_dTVHDReloaded)
	touch $@

$(DEPDIR)/e2skin-dTVHDReloaded: e2skin-dTVHDReloaded.do_prepare
	$(start_build)
	cd $(DIR_e2skin_dTVHDReloaded) && \
		cp -a usr $(PKDIR)
	$(toflash_build)
	touch $@

e2skin-dTVHDReloaded-distclean:
	rm -f $(DEPDIR)/e2skin-dTVHDReloaded.do_prepare
	rm -rf $(DIR_e2skin_dTVHDReloaded)

