#
# TARGET-FILESYSTEM
#
package[[ target_filesystem

BDEPENDS_${P} =

PV_${P} = 0.1
PR_${P} = 4

SRC_URI_${P} = empty

call[[ base ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P}) | targetsh4-env
# 	install -d $(ipktarget)
# 	install -d {$(targetsh4prefix),$(targetboxprefix)}/usr/lib/opkg
# 	install -d {$(targetsh4prefix),$(targetboxprefix)}/etc
# # make aclocal happy
# 	install -d {$(targetsh4prefix),$(targetsh4prefix)}/usr/share/aclocal
# 	( echo "dest target-sh4-root /"; \
# 	  echo "lists_dir ext /usr/lib/opkg"; \
# 	  echo "arch $(box_arch) 16"; \
# 	  echo "arch sh4 10"; \
# 	  echo "arch all 1"; \
# 	  echo "src/gz target file://$(ipktarget)"; \
# 	) > $(targetsh4_opkg_conf)
# 	( echo "dest target-$(TARGET)-root /"; \
# 	  echo "lists_dir ext /usr/lib/opkg"; \
# 	  echo "arch $(box_arch) 16"; \
# 	  echo "arch sh4 10"; \
# 	  echo "arch all 1"; \
# 	  echo "src/gz target file://$(ipktarget)"; \
# 	) > $(targetbox_opkg_conf)
# 
# 	install -d $(ipkbox)
# 	( echo "dest $(TARGET)-root /"; \
# 	  echo "lists_dir ext /usr/lib/opkg"; \
# 	  echo "arch $(box_arch) 16"; \
# 	  echo "arch sh4 10"; \
# 	  echo "arch all 1"; \
# 	  echo "src/gz box file://$(ipkbox)"; \
# 	) > $(box_opkg_conf)

	# make aclocal happy
	$(PKDIR_clean)
	install -d $(PKDIR)/usr/share/aclocal
	touch $@

]]package
