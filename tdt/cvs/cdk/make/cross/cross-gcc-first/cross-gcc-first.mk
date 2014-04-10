#
# CROSS GCC
#
package[[ cross_gcc_first

BDEPENDS_${P} = $(target_kernel_headers) $(target_glibc_headers) $(cross_mpc) $(cross_libelf)

PR_${P} = 1

ifdef CONFIG_GCC48
${P}_VERSION = 4.8.2-131
else
${P}_VERSION = 4.7.3-124
endif

ST_PN_${P} = cross-gcc
${P}_SPEC = stm-${ST_PN}.spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-${ST_PN}.$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-${ST_PN}-$(${P}_VERSION).src.rpm

# NAME_${P} = libgcc1
# DESCRIPTION_${P} =  The GNU cc and gcc C compilers.
# FILES_${P} = /lib/libgcc_s*

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

#call[[ TARGET_rpm_do_compile ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(rpm_src_install) $(${P}_SRCRPM)
	cp $(buildprefix)/my-$(${P}).spec $(specsprefix)/$(${P}_SPEC)
	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < $(buildprefix)/Patches/$(${P}_SPEC_PATCH) )
	$(if $(${P}_PATCHES), cp $(${P}_PATCHES:%=Patches/%) $(sourcesprefix) )
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
#	rm -rf $(prefix)/BUILDROOT/*
	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(fromrpm_copy)
	
	rm -f $(PKDIR)/$(crossprefix)/lib/libiberty.a
	touch $@

]]package