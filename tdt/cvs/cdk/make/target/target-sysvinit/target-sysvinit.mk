#
# AR-P buildsystem smart Makefile
#
package[[ target_sysvinit

BDEPENDS_${P} = $(target_filesystem) $(target_glibc)

PR_${P} = 1

${P}_VERSION = 2.86-15
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_target_rpm ]]
call[[ ipk ]]

NAME_${P} = ${PN}
FILES_${P} = \
	/sbin/fsck.nfs \
	/sbin/killall5 \
	/sbin/init \
	/sbin/halt \
	/sbin/poweroff \
	/sbin/shutdown \
	/sbin/reboot

call[[ ipkbox ]]

]]package