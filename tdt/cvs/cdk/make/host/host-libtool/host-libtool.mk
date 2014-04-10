#
# LIBTOOL
#
package[[ host_libtool

BDEPENDS_${P} = $(host_ccache)

PV_${P} = 2.4.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ftp.gnu.org/gnu/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}-duckbox-branding.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	echo "sys_lib_search_path_spec='$(targetprefix)/lib $(targetprefix)/usr/lib'" > $(DIR_${P})/config.cache
	echo "lt_cv_sys_lib_dlsearch_path_spec='$(targetprefix)/lib $(targetprefix)/usr/lib'" >> $(DIR_${P})/config.cache
	cd $(DIR_${P}) && \
		./configure \
		lt_cv_sys_lib_search_path_spec="" \
		lt_cv_sys_dlsearch_path="" \
		--cache-file=config.cache \
		--prefix=$(hostprefix) \
	&& \
	make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

]]package