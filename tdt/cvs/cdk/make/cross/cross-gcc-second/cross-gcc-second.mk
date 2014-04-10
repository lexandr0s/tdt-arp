#
# CROSS GCC
#
package[[ cross_gcc_second

BDEPENDS_${P} = $(target_glibc_first)
BREPLACES_${P} = $(cross_gcc_first)

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

NAME_${P} = $(${P})

# NAME_${P} = libgcc1
# DESCRIPTION_${P} =  The GNU cc and gcc C compilers.
# FILES_${P} = /lib/libgcc_s*

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

#call[[ TARGET_rpm_do_compile ]]

call[[ TARGET_cross_rpm ]]

# $(TARGET_${P}).do_prepare: $(DEPENDS_${P})
# 	$(rpm_src_install) $(${P}_SRCRPM)
# 	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < $(buildprefix)/Patches/$(${P}_SPEC_PATCH) )
# 	$(if $(${P}_PATCHES), cp $(${P}_PATCHES:%=Patches/%) $(sourcesprefix) )
# 	touch $@
# 
# $(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
# 	rm -rf $(prefix)/BUILDROOT/*
# 	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
# 	touch $@
# 
# # ugly hack. pacakge cross-gcc-lib before other package will rewrite BUILDROOT
# $(TARGET_${P}): $(TARGET_${P}).do_package $(target_cross_gcc_lib).do_package
# 	opkg $(cross_ipkg_args) remove $(cross_gcc)
# 	$(opkg_install_cross) $(ipkcross)/$(IPK_${P})
# 	touch $@
# 
# $(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
# 	$(start_build)
# 	install -d $(PKDIR)/$(crossprefix)/
# 	cp -r $(prefix)/BUILDROOT/*/$(crossprefix)/* $(PKDIR)/$(crossprefix)/
# 	$(tocross_build)
# 	touch $@

]]package