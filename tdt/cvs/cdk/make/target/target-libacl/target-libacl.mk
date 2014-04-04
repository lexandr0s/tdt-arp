#
# AR-P buildsystem smart Makefile
#
package[[ target_libacl

BDEPENDS_${P} = $(target_glibc)

PR_${P} = 2

${P}_VERSION = 2.2.47-6
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package