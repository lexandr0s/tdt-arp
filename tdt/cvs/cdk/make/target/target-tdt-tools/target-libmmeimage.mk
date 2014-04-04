#
# FONTCONFIG
#
package[[ target_libmmeimage

BDEPENDS_${P} = $(target_glibc)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = libmmeimage
FILES_${P} = /lib/libmmeimage.*

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package