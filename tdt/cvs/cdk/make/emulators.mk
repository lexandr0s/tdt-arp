#
# Packages softcams binaries
#
PKGR_softcams = r1
BEGIN[[
softcams
	git
	{PN}-{PV}
	# You can separate with ';' if ':' is in use
	git://github.com:schpuntik/cams.git;protocol=ssh
]]END

$(DEPDIR)/softcams: $(DEPENDS_softcams)
	$(PREPARE_softcams)
	$(start_build)
	# Directory tree is ready for ipkg-buildpackage
	rm -rf $(ipkgbuilddir)/*
	cp -r $(DIR_softcams)/* $(ipkgbuilddir)
	$(call do_build_pkg,none,flash)
	touch $@