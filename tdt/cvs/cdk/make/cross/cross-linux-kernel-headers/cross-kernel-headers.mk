#
# CROSS KERNEL HEADERS
#

# assume gcc depends on common headers for all targets
package[[ target_kernel_headers

BDEPENDS_${P} = $(target_filesystem)

PR_${P} = 2
ifeq ($(CONFIG_KERNEL_0211),y)
${P}_VERSION = 2.6.32.46-47
endif
ifeq ($(CONFIG_KERNEL_0215),y)
${P}_VERSION = 2.6.32.46-48
endif
${P}_SPEC = stm-target-${PN}-kbuild.spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-target-linux-${PN}-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

call[[ TARGET_rpm_do_compile ]]

# $(TARGET_${P}): $(TARGET_${P}).do_package
# 	$(opkg_install_target) $(ipktarget)/$(IPK_${P})
# 	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(fromrpm_copy)
	mv $(PKDIR)/$(targetprefix)/* $(PKDIR)/
	touch $@

]]package