#
# CROSS GCC
#
package[[ target_glibc_first

BDEPENDS_${P} = $(cross_gcc_first)
BREPLACES_${P} = $(target_glibc_headers)

PR_${P} = 1

${P}_VERSION = 2.14.1-48

${P}_SPEC = stm-target-glibc.spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-target-glibc-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

#call[[ rpm ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(rpm_src_install) $(${P}_SRCRPM)
	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < $(buildprefix)/Patches/$(${P}_SPEC_PATCH) )
	$(if $(${P}_PATCHES), cp $(${P}_PATCHES:%=Patches/%) $(sourcesprefix) )
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
#	gcc-first has no libgcc_s and libgcc_eh libs
#	this hack is suggested somewhere in the net
	ln -sfv libgcc.a `$(target)-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`
	ln -sfv libgcc.a `$(target)-gcc -print-libgcc-file-name | sed 's/libgcc/&_s/'`

#	rm -rf $(prefix)/BUILDROOT/*

	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
	touch $@

# $(TARGET_${P}): $(TARGET_${P}).do_ipk
# 	opkg $(target_ipkg_args) remove $(target_glibc_headers)
# 	opkg $(target_ipkg_args) install $(IPK_${P})
# 	touch $@

call[[ rpm ]]

]]package