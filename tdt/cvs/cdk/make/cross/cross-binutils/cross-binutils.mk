#
# CROSS BINUTILS
#
package[[ cross_binutils

BDEPENDS_${P} = $(cross_filesystem)

PR_${P} = 1

${P}_VERSION = 2.23.2-72
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-$(${P}).$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ TARGET_cross_rpm ]]

]]package