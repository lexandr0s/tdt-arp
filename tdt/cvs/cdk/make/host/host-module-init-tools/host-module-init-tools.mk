#
# HOST-MTD-UTILS
#
package[[ host_module_init_tools

BDEPENDS_${P} = host-opkg-meta $(host_rpmconfig) $(host_autotools)

PR_${P} = 2

${P}_VERSION = 3.16-3
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = stm-$(${P}).spec.diff
${P}_PATCHES = ${PN}-no-man.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_host_rpm ]]

]]package