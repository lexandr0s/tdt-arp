#
# AR-P buildsystem smart Makefile
#
package[[ target_gcc

BDEPENDS_${P} = $(target_filesystem) $(target_glibc) $(target_zlib) $(target_mpc) $(target_libelf)
BREPLACES_${P} = $(target_cross_gcc_lib)

PR_${P} = 1

ifdef CONFIG_GCC483
${P}_VERSION = 4.8.3-141
endif
ifdef CONFIG_GCC482
${P}_VERSION = 4.8.2-141
endif
ifdef CONFIG_GCC473
${P}_VERSION = 4.7.3-129
endif

${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-$(${P}).$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

# Provides libs that comes with gcc
call[[ target_gcc_lib_in ]]

call[[ ipkbox ]]

]]package
