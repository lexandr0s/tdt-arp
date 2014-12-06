#
# CROSS GCC
#
package[[ cross_gcc_second

BDEPENDS_${P} = $(target_glibc_first)
BREPLACES_${P} = $(cross_gcc_first)

PR_${P} = 1
ST_PN_${P} = cross-gcc

ifdef CONFIG_GCC483
 ST_PV_${P} = 4.8.3
 ST_PR_${P} = 137
else
 ST_PV_${P} = 4.7.3
 ST_PR_${P} = 124
endif

call[[ base ]]
call[[ ipk ]]


# build from spec
#############################################################################
ifndef CONFIG_AVOID_RPM_SPEC

${P}_VERSION := ${ST_PV}-${ST_PR}

${P}_SPEC = stm-${ST_PN}.spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(${P}_VERSION).diff
${P}_PATCHES = stm-${ST_PN}.$(${P}_VERSION).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-${ST_PN}-$(${P}_VERSION).src.rpm

call[[ base_rpm ]]
# FIXME: this rpm spec has bug and installs some packages directly to $(crossprefix)/$(target)
# but this directory is never used // not critical
call[[ rpm ]]



else
# my build
#############################################################################
PV_${P} := ${ST_PV}-${ST_PR}
DIR_${P} = $(WORK_${P})/gcc-${ST_PV}

rule[[
  dirextract:local://$(archivedir)/$(STLINUX)-cross-gcc-${ST_PV}-${ST_PR}.src.rpm
  extract:localwork://$(DIR_${P})/gcc-${ST_PV}.tar.bz2
# Our patches
  patch:file://stm-${ST_PN}.${ST_PV}-${ST_PR}.diff
# check these patches when stlinux src.rpm updates
  patch:localwork://gcc-${ST_PV}-stm-130807.patch
  patch:localwork://gcc-4.7.0-sh-use-gnu-hash-style.patch
  patch:localwork://gcc-4.2.4-multilibpath.patch
  patch:localwork://gcc-4.5.2-sysroot.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	cd $(DIR_${P}) && echo 'STMicroelectronics/Linux Base ${ST_PV}-${ST_PR}' > gcc/DEV-PHASE
	touch $@

CONFIG_FLAGS_${P} = \
	--prefix=$(crossprefix) \
	--target=$(target) \
	\
	--program-prefix=$(target)- \
	--with-sysroot=$(targetprefix) \
	--enable-target-optspace \
	--enable-languages=c,c++ \
	--enable-threads=posix \
	--enable-c99 \
	--enable-long-long \
	--with-system-zlib \
	--enable-shared \
	--disable-libgomp \
	--with-pkgversion="GCC" \
	--with-bugurl="https://bugzilla.stlinux.com" \
	--disable-libitm \
	--disable-multi-sysroot \
	--with-multilib-list=m4-nofpu \
	--enable-lto \
	--enable-symvers=gnu \
	--with-mpcx2=$(crossprefix) \
	--with-gmp=$(crossprefix) \
	--with-mpfr=$(crossprefix) \
	--without-ppl \
	--with-gxx-include-dir=$(crossprefix)/$(target)/usr/include/c++/${ST_PV} \
	--enable-__cxa_atexit

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		mkdir -p objdir && cd objdir && \
		../configure ${CONFIG_FLAGS} \
		&& \
		make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P})/objdir && \
	    make install DESTDIR=$(PKDIR)

#	$(call compress_man, $(PKDIR)/$(stm_cross_info_dir))
#	$(call compress_man, $(PKDIR)/$(stm_cross_man_dir))
	
# 	install -d $(PKDIR)/$(crossprefix)/$(target)/bin
# 	
# 	ln -s ../../bin/$(target)-gcc $(PKDIR)/$(crossprefix)/$(target)/bin/cc
# 	ln -s ../../bin/$(target)-gcc $(PKDIR)/$(crossprefix)/$(target)/bin/gcc
# 	ln -s ../../bin/$(target)-gcov $(PKDIR)/$(crossprefix)/$(target)/bin/gcov
# 	ln -s ../../bin/$(target)-g++ $(PKDIR)/$(crossprefix)/$(target)/bin/c++
# 	ln -s ../../bin/$(target)-g++ $(PKDIR)/$(crossprefix)/$(target)/bin/g++
# 	ln -s ../../bin/$(target)-cpp $(PKDIR)/$(crossprefix)/$(target)/bin/cpp
# 	ln -s ../../bin/$(target)-cpp $(PKDIR)/$(crossprefix)/$(target)/lib/cpp

	mv $(PKDIR)/$(crossprefix)/lib/gcc/$(target)/${ST_PV}/include-fixed/* \
	   $(PKDIR)/$(crossprefix)/lib/gcc/$(target)/${ST_PV}/include/
	
	mv $(PKDIR)/$(crossprefix)/$(target)/lib/libgcc_s.so.1 \
	   $(PKDIR)/$(crossprefix)/$(target)/lib/libgcc_s-${ST_PV}.so.1

	ln -s libgcc_s-${ST_PV}.so.1 $(PKDIR)/$(crossprefix)/$(target)/lib/libgcc_s.so.1

	# This is a text file, so shift it to the right place.
	mv $(PKDIR)/$(crossprefix)/$(target)/lib/libgcc_s.so \
	   $(PKDIR)/$(crossprefix)/lib/gcc/$(target)/${ST_PV}/libgcc_s.so

	# TODO: Same for m4-nofpu

# ifeq ($(strip $(ARP_ENABLE_MULTILIB)),y)
# 	mv $(PKDIR)/$(stm_cross_targetconf_dir)/lib/m4-nofpu/libgcc_s.so \
# 	$(PKDIR)/$(stm_cross_lib_dir)/gcc/$(stm_target_config)/4.7.2/m4-nofpu/libgcc_s.so
# 	mkdir -p $(PKDIR)/$(stm_cross_target_dir)/lib/m4-nofpu
# 	mv $(PKDIR)/$(stm_cross_targetconf_dir)/lib/m4-nofpu/libgcc_s.so.1 \
# 	$(PKDIR)/$(stm_cross_target_dir)/lib/m4-nofpu/libgcc_s-4.7.2.so.1
# 	ln -s m4-nofpu/libgcc_s-4.7.2.so.1 \
#         $(PKDIR)/$(stm_cross_target_dir)/lib/m4-nofpu/libgcc_s.so.1
# endif
	
# 	rm $(PKDIR)/$(stm_cross_targetconf_dir)/lib/libstdc++*
# 	rm $(PKDIR)/$(stm_cross_targetconf_dir)/lib/libsupc++*
# 	rm -rf $(PKDIR)/$(stm_cross_target_dir)/$(stm_target_include_dir)/c++
# ifeq ($(strip $(ARP_ENABLE_MULTILIB)),y)
# 	rm $(PKDIR)/$(stm_cross_targetconf_dir)/lib/m4-nofpu/libstdc++*
# 	rm $(PKDIR)/$(stm_cross_targetconf_dir)/lib/m4-nofpu/libsupc++*
# endif

# 	find $(PKDIR)/$(stm_cross_targetconf_dir)/lib \
# 	\( -name "libmudflap*" -o -name "libssp*" \) -print | \
# 	xargs --no-run-if-empty --verbose rm

# 	rm $(PKDIR)/$(stm_cross_info_dir)/cppinternals.info.gz
# 	rm $(PKDIR)/$(stm_cross_info_dir)/gccinstall.info.gz
# 	rm $(PKDIR)/$(stm_cross_info_dir)/gccint.info.gz
# 	rm -f $(PKDIR)/$(stm_cross_info_dir)/dir.*
# 	rm -r $(PKDIR)/$(stm_cross_lib_dir)/gcc/$(stm_target_config)/4.7.2/install-tools

	# Comes from binutils
	rm -f $(PKDIR)/$(crossprefix)/lib/libiberty.a
	rm -f $(PKDIR)/$(crossprefix)/lib64/libiberty.a

# 	rm -r $(PKDIR)/$(stm_cross_libexec_dir)/gcc/$(stm_target_config)/4.7.2/install-tools
# 	rm -rf $(PKDIR)/$(stm_cross_targetconf_dir)/share/gcc-4.7.2/python

	# In spec they removes these libs, but they are ok
	install -d $(PKDIR)/$(targetprefix)
	cp -ar $(PKDIR)/$(crossprefix)/$(target)/* $(PKDIR)/$(targetprefix)
	install -d $(PKDIR)/$(targetprefix)/usr/lib
	find $(PKDIR)/$(targetprefix)/lib -maxdepth 1 ! -type d -! -name 'libgcc*' \
		-exec mv {} $(PKDIR)/$(targetprefix)/usr/lib \;

	touch $@

endif #CONFIG_AVOID_RPM_SPEC

]]package
