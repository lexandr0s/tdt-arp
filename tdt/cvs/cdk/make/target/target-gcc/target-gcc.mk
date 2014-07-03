#
# AR-P buildsystem smart Makefile
#
package[[ target_gcc

BDEPENDS_${P} = $(target_filesystem) $(target_glibc) $(target_zlib) $(target_mpc) $(target_libelf)
BREPLACES_${P} = $(target_cross_gcc_lib)

PR_${P} = 1

ifdef CONFIG_GCC48
${P}_VERSION := 4.8.2-138
else
${P}_VERSION := 4.7.3-129
endif

${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-$(${P}).$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

PACKAGES_${P} = libgcc libstdcxx libstdcxx_dev

NAME_libgcc = libgcc1
DESCRIPTION_libgcc =  The GNU cc and gcc C compilers.
RDEPENDS_libgcc = libc6
FILES_libgcc = /lib/libgcc_s*

NAME_libstdcxx = libstdc++6
DESCRIPTION_libstdcxx = libstdc++
RDEPENDS_libstdcxx = libgcc1
FILES_libstdcxx = /usr/lib/libstdc++.so.*

NAME_libstdcxx_dev = libstdc++6-dev
DESCRIPTION_libstdcxx_dev = libstdc++
RDEPENDS_libstdcxx_dev = libstdc++6
FILES_libstdcxx_dev = /usr/include /usr/lib/*.*

call[[ ipkbox ]]

]]package
