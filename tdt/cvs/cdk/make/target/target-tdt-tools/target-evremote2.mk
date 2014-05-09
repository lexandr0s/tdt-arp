#
# FONTCONFIG
#
package[[ target_evremote2

BDEPENDS_${P} = $(target_glibc)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = evremote2
FILES_${P} = /bin/evremote2 /bin/evtest


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
