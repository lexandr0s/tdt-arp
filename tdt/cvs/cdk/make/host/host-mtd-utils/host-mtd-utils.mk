#
# HOST-MTD-UTILS
#
package[[ host_mtd_utils

BDEPENDS_${P} = host-opkg-meta $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

${P}_VERSION = 1.0.1-8
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/stlinux23-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_rpm_do_compile ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(subst stlinux23,stlinux24,$(fromrpm_copy))
	touch $@

]]package