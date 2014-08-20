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
$(TARGET_${P}).do_compile: $(cross_gcc_second).do_package
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	mv $(WORK_cross_gcc_second)/root/$(targetprefix)/* $(PKDIR)
	touch $@

call[[ ipk ]]

]]package