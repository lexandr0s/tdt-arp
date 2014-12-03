#
# AR-P buildsystem smart Makefile
#
package[[ target_evremote2

BDEPENDS_${P} = $(target_glibc) $(target_lirc) $(target_initscripts)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = evremote2
RDEPENDS_${P} = lirc initscripts
FILES_${P} = /bin/evremote2 /bin/evtest


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
