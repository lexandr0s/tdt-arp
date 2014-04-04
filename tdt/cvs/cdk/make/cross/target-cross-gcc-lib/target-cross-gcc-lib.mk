#
# BINUTILS
#
package[[ target_cross_gcc_lib

BDEPENDS_${P} = $(cross_gcc_second)

PV_${P} = $(PV_cross_gcc_second)
PR_${P} = $(PR_cross_gcc_second)

SRC_URI_${P} = $(SRC_URI_cross_gcc_second)

call[[ base ]]

# packaged from cross-gcc
${P}_SRCRPM = $(cross_gcc_second_SRCRPM)
$(TARGET_${P}).do_compile: $(cross_gcc_second).do_package
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(fromrpm_copy)
	rm -rf $(PKDIR)/$(crossprefix)
	mv $(PKDIR)/$(targetprefix)/* $(PKDIR)
	touch $@

]]package