#
# HOST AUTOMAKE
#
package[[ cross_libelf

BDEPENDS_${P} = $(cross_binutils)

PR_${P} = 1

${P}_VERSION = 0.8.13-2
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_cross_rpm ]]
call[[ ipk ]]

]]package