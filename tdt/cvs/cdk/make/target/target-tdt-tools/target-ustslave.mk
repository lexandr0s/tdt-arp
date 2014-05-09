#
# FONTCONFIG
#
package[[ target_ustslave

BDEPENDS_${P} = $(target_glibc)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = ustslave
FILES_${P} = /bin/ustslave

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
