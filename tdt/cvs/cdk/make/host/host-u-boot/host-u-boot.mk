#
# HOST-MTD-UTILS
#
package[[ cross_u_boot

BDEPENDS_${P} = $(host_rpmconfig) $(host_autotools) $(cross_filesystem)

PR_${P} = 2

ST_PN_${P} = host-u-boot
ST_PV_${P} = sh4-1.3.1_stm24_0048
${P}_VERSION = ${ST_PV}-48
${P}_SPEC = stm-${ST_PN}.spec
${P}_SPEC_PATCH = uboot-1.3.1_spec_stm24.patch
${P}_PATCHES = uboot-1.3.1_lzma_stm24.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-${ST_PN}-source-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

$(TARGET_${P}).do_install_post: $(TARGET_${P}).do_install
	rm -f $(crossprefix)/sources/u-boot/u-boot-sh4
	ln -s u-boot-${ST_PV} $(crossprefix)/sources/u-boot/u-boot-sh4
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install_post

call[[ ipk ]]

]]package