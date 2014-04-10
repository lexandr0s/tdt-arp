#
# HOST AUTOTOOLS
#
package[[ host_autotools

BDEPENDS_${P} = $(host_opkg_meta) $(host_rpmconfig) $(host_ccache)

PR_${P} = 1

${P}_VERSION = dev-20091012-3
${P}_SPEC = stm-$(${P})-dev.spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ TARGET_host_rpm ]]

]]package