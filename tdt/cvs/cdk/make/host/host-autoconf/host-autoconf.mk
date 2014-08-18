#
# HOST AUTOMAKE
#
package[[ host_autoconf

BDEPENDS_${P} = $(host_opkg_meta) $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

${P}_VERSION = 2.64-6
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = stm-$(${P}).$(${P}_VERSION).spec.diff
${P}_PATCHES = stm-$(${P}).$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ TARGET_host_rpm ]]

]]package