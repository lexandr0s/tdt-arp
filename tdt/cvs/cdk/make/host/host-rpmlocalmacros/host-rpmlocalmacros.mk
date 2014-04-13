#
# HOST-RPMCONFIG
#
package[[ host_rpmlocalmacros

BDEPENDS_${P} = $(host_opkg_meta)

PV_${P} = 0.1
PR_${P} = 9

call[[ base ]]

$(TARGET_${P}).do_install: $(DEPENDS_${P})
	( echo "%_topdir $(prefix)"; \
	  #echo "%_specdir %_topdir/SPECS"; \
	  #echo "%_sourcedir %_topdir/SOURCES"; \
	  echo "%_builddir $(workprefix)"; \
	  echo "%_buildrootdir $(prefix)/BUILDROOT"; \
	  echo "%buildroot %_topdir/BUILDROOT/%{name}-%{version}-%{release}.$(host_arch)"; \
	  #echo "%_rpmdir %_topdir/RPMS"; \
	  #echo "%_srcrpmdir %_topdir/SRPMS"; \
	  #echo "%_stm_install_prefix $prefix/.."; \
	  echo "%_stm_base_prefix $(prefix)"; \
	  echo "%_stm_host_dir $(hostprefix)"; \
	  echo "%_stm_cross_dir $(crossprefix)"; \
	  echo "%_stm_config_dir $(configprefix)"; \
	  echo "%_stm_devkit_dir $(devkitprefix)"; \
	  echo "%_stm_cross_target_dir $(targetprefix)"; \
	  #echo "%_stm_kernel_dir $kernelprefix"; \
	  #echo "%_stm_sources_dir $kernelprefix"; \
	  #echo "%_stm_host_arch $(host_arch)"; \
	  #echo "%_stm_host_cpu ${host_cpu}"; \
	  #echo "%_stm_host_config ${host_alias:-${host}}"; \
	  #echo "%_dbpath $(rpmdbprefix)"; \
	  #echo "%__bzip2 $BZIP2"; \
	  echo "%nohostbuilddeps 1"; \
	  echo "%_default_patch_fuzz 2"; \
	) > localmacros

	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package
