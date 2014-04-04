#
# HOST AUTOTOOLS
#
package[[ host_autotools

BDEPENDS_${P} = host-opkg-meta $(host_rpmconfig)

PR_${P} = 1

${P}_VERSION = dev-20091012-3
${P}_SPEC = stm-$(${P})-dev.spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_host_rpm ]]

]]package