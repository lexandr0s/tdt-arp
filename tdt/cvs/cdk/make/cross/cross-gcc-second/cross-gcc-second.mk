#
# CROSS GCC
#
package[[ cross_gcc_second

BDEPENDS_${P} = $(target_glibc_first)
BREPLACES_${P} = $(cross_gcc_first)

PR_${P} = 1

ifdef CONFIG_GCC48
 PV_${P} = 4.8.2
 ST_PR_${P} = 131
else
 PV_${P} = 4.7.3
 ST_PR_${P} = 124
endif

${P}_VERSION = ${PV}-${ST_PR}

ST_PN_${P} = cross-gcc
${P}_SPEC = stm-${ST_PN}.spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-${ST_PN}.$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-${ST_PN}-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

call[[ rpm ]]

]]package
