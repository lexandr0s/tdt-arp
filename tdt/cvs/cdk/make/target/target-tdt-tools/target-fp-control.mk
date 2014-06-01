#
# FONTCONFIG
#
package[[ target_fp_control

BDEPENDS_${P} = $(target_glibc) $(target_driver_headers)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = frontprocessor control
FILES_${P} = /bin/fp_control


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
