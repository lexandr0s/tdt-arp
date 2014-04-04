#
# AR-P buildsystem smart Makefile
#
package[[ target_libelf

BDEPENDS_${P} = $(target_filesystem)

PR_${P} = 1

${P}_VERSION = $(cross_libelf_VERSION)
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package