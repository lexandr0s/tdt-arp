#
# AR-P buildsystem smart Makefile
#
package[[ target_showiframe

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = shows picture on the screen
FILES_${P} = /bin/showiframe

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
