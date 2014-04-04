#
# AR-P buildsystem smart Makefile
#
package[[ target_gmp

BDEPENDS_${P} = $(target_filesystem)

PR_${P} = 1

${P}_VERSION = 5.1.3-10
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

]]package