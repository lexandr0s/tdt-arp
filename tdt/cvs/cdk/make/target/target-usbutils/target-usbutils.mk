#
# AR-P buildsystem smart Makefile
#
package[[ target_usbutils

BDEPENDS_${P} = $(target_filesystem) $(target_libusb_compat)

PR_${P} = 1

${P}_VERSION = 0.86-11
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]
call[[ ipkbox ]]

]]package