#
# FONTCONFIG
#
package[[ target_stfbcontrol

BDEPENDS_${P} = $(target_glibc)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = framebuffer control
FILES_${P} = /bin/stfbcontrol

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
