#
# AR-P buildsystem smart Makefile
#
package[[ target_mpc

BDEPENDS_${P} = $(target_mpfr)

PR_${P} = 1

${P}_VERSION = 1.0.1-5
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package