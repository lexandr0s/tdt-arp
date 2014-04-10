#
# HOST AUTOMAKE
#
package[[ cross_mpc

BDEPENDS_${P} = $(cross_mpfr)

PR_${P} = 1

${P}_VERSION = 1.0.2-7
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ TARGET_cross_rpm ]]

]]package