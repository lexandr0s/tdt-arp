#
# HOST-MTD-UTILS
#
package[[ host_u_boot_tools

BDEPENDS_${P} = $(cross_u_boot)

PR_${P} = 1

${P}_VERSION = 1.3.1_stm24-8
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package