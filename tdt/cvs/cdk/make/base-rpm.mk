# for building rpms from stlinux
function[[ base_rpm

# place after variables definitions in *.mk file and before TARGET
PV_${P} = $(${P}_VERSION)
SRC_URI_${P} ?= stlinux.com
DEPENDS_${P} += $(if $(${P}_SPEC_PATCH),${SDIR}/$(${P}_SPEC_PATCH))
DEPENDS_${P} += $(if $(${P}_PATCHES),$(addprefix ${SDIR}/,$(${P}_PATCHES)))
DEPENDS_${P} += $(${P}_SRCRPM)

]]function

function[[ rpm_do_prepare

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(rpm_src_install) $(${P}_SRCRPM)
	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < ${SDIR}/$(${P}_SPEC_PATCH) )
	$(if $(${P}_PATCHES), cp $(addprefix ${SDIR}/,$(${P}_PATCHES)) $(sourcesprefix) )
	touch $@

]]function

#FIXME:
function[[ rpm_do_compile

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
	touch $@
]]function

function[[ rpm_do_package

DO_PACKAGE_${P} ?=

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
ifeq (${SYSROOT},target)
	mv $(PKDIR)/$(targetprefix)/* $(PKDIR)
endif
	$(DO_PACKAGE_${P})
	touch $@

]]function

function[[ rpm
call[[ rpm_do_prepare ]]
call[[ rpm_do_compile ]]
call[[ rpm_do_package ]]
]]function

# FIXME: rename
function[[ TARGET_host_rpm
call[[ rpm ]]
]]function

function[[ TARGET_cross_rpm
call[[ rpm ]]
]]function

function[[ TARGET_target_rpm
call[[ rpm ]]
]]function

function[[ TARGET_rpm_do_compile
call[[ rpm_do_compile ]]
]]function
function[[ TARGET_rpm_do_package
call[[ rpm_do_package ]]
]]function
