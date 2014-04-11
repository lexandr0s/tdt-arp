#
# CROSS-FILESYSTEM
#
package[[ cross_filesystem

DEPENDS_${P} = bootstrap-host

PV_${P} = 0.1
PR_${P} = 5

SRC_URI_${P} = empty

call[[ base ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P})
	install -d $(ipkcross)
	install -d $(crossprefix)

	$(PKDIR_clean)
	install -d $(PKDIR)/$(crossprefix)/etc
	touch $@

call[[ ipk ]]

]]package
