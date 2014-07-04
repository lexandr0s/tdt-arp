#
# HOST AUTOMAKE
#
package[[ host_automake

BDEPENDS_${P} = host-opkg-meta $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

${P}_VERSION = 1.11.1-4
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ TARGET_host_rpm ]]

]]package