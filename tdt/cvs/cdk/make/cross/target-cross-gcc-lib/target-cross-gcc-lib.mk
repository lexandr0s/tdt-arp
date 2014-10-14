#
# LIBS FROM GCC
#
package[[ target_cross_gcc_lib

BDEPENDS_${P} = $(cross_gcc_second)

PV_${P} = $(PV_cross_gcc_second)
PR_${P} = $(PR_cross_gcc_second)

SRC_URI_${P} = $(SRC_URI_cross_gcc_second)

call[[ base ]]

# packaged from cross-gcc
$(TARGET_${P}).do_package: $(cross_gcc_second).do_package
	$(PKDIR_clean)
	cp -ar $(WORK_cross_gcc_second)/root/$(targetprefix)/* $(PKDIR)
	touch $@

call[[ ipk ]]
# Ask to not RM_WORK util we finished
$(cross_gcc_second): $(TARGET_${P}).do_ipk

ifdef CONFIG_GCC_LIB_FROM_CROSS
call[[ target_gcc_lib_in ]]
call[[ ipkbox ]]
# Ask to not RM_WORK util we finished
$(cross_gcc_second): $(TARGET_${P}).do_ipkbox
endif

]]package
