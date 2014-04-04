#
# CROSS-FILESYSTEM
#
package[[ cross_filesystem

DEPENDS_${P} = bootstrap-host

BDEPENDS_${P} = 

PV_${P} = 0.1
PR_${P} = 5

SRC_URI_${P} = empty

call[[ base ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P}) | cross-env
	install -d $(ipkcross)
	install -d $(crossprefix)/usr/lib/opkg
	install -d $(crossprefix)/etc
	install -d $(ipktarget)
	install -d $(targetsh4prefix)/etc
	install -d $(targetsh4prefix)/usr/lib/opkg
# 	( echo "dest crossroot /"; \
# 	  echo "lists_dir ext /usr/lib/opkg"; \
# 	  echo "arch $(box_arch) 16"; \
# 	  echo "arch sh4 10"; \
# 	  echo "arch all 1"; \
# 	  echo "src/gz cross file://$(ipkcross)"; \
# 	) > $(cross_opkg_conf)
	
	$(PKDIR_clean)
	install -d $(PKDIR)/$(crossprefix)/etc
	
	touch $@

]]package
