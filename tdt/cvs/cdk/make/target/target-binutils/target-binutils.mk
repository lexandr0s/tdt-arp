#
# BINUTILS
#
package[[ target_binutils

BDEPENDS_${P} = $(target_filesystem) $(cross_gcc_second) $(target_cross_gcc_lib)

PR_${P} = 1

${P}_VERSION = 2.24.51.0.3-79
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-$(${P}).$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package
