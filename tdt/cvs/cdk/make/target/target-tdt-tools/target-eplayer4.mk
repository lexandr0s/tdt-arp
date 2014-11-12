#
# AR-P buildsystem smart Makefile
#
package[[ target_eplayer4

BDEPENDS_${P} = $(target_glibc) $(target_gstreamer)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = eplayer4
FILES_${P} = /usr/bin/eplayer4


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
