package[[ host_opkg_meta

DEPENDS_${P} = $(host_opkg) $(host_ipkg_utils)

PV_${P} = 0.1
PR_${P} = 2

call[[ base ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})

	install -d $(prefix)/usr/lib/opkg
	( echo "dest targetroot /target"; \
	  echo "dest crossroot /devkit/sh4"; \
	  echo "dest hostroot /host"; \
	  echo "arch $(box_arch) 16"; \
	  echo "arch sh4 10"; \
	  echo "arch all 1"; \
	) > $(prefix)/opkg.conf

	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	install -d $(PKDIR)/$(hostprefix)/etc
	touch $@

SRC_URI_${P} = empty

call[[ ipk ]]

]]package

$(DEPDIR)/bootstrap-host: | \
  $(host_autoconf) $(host_automake) $(host_autotools) $(host_pkg_config) $(host_libtool) \
  $(host_module_init_tools) $(host_mtd_utils)
#TODO: $(host_lndir)
	touch $@
