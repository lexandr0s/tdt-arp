#
# HOST-RPMCONFIG
#
package[[ host_rpmconfig

BDEPENDS_${P} = host-opkg-meta $(host_rpmlocalmacros)

PR_${P} = 2

${P}_VERSION = 2.4-33
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-$(${P})-$(${P}_VERSION)-ignore-skip-cvs-errors.patch \
               stm-$(${P})-$(${P}_VERSION)-autoreconf-add-libtool-macros.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_rpm_do_compile ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(fromrpm_copy)
	install -d $(PKDIR)/$(hostprefix)/
	mv $(PKDIR)/opt/STM/STLinux-2.4/* $(PKDIR)/$(hostprefix)/
	rm -rf $(PKDIR)/opt
	touch $@

]]package