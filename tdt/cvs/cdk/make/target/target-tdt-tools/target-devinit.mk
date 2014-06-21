#
# AR-P buildsystem smart Makefile
#
package[[ target_devinit

BDEPENDS_${P} = $(target_glibc)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = devinit
FILES_${P} = /bin/devinit

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
