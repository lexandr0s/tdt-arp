#
# HOST-MTD-UTILS
#
package[[ cross_u_boot

BDEPENDS_${P} = $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

ST_PN_${P} = host-u-boot

${P}_VERSION = sh4-1.3.1_stm24_0048-48
${P}_SPEC = stm-${ST_PN}.spec
${P}_SPEC_PATCH = uboot-1.3.1_spec_stm24.patch
${P}_PATCHES = uboot-1.3.1_lzma_stm24.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-${ST_PN}-source-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_rpm_do_compile ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(fromrpm_copy)

	rm -rf $(devkitprefix)/sources
	ln -sf sh4/sources $(devkitprefix)/sources

	install -d $(PKDIR)/$(crossprefix)/sources/u-boot/
	mv $(PKDIR)/$(devkitprefix)/sources/u-boot/u-boot-* $(PKDIR)/$(crossprefix)/sources/u-boot/u-boot-sh4

	touch $@

call[[ ipk ]]

]]package