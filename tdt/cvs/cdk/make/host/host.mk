$(DEPDIR)/host-opkg-meta: $(host_opkg) $(host_ipkg_utils)
	touch $@

$(DEPDIR)/bootstrap-host: | \
  $(host_autoconf) $(host_automake) $(host_autotools) $(host_pkg_config) $(host_libtool) \
  $(host_module_init_tools) $(host_mtd_utils)
#TODO: $(host_lndir)
	touch $@
