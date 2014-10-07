#
# HOST MAKE
#
package[[ host_make

PV_${P} = 3.82
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ftp.gnu.org/gnu/make/make-${PV}.tar.bz2
  patch:file://make-3.82-upstream_fixes-3.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./configure \
			--prefix=$(hostprefix) \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR) && \
	rm $(PKDIR)/$(hostprefix)/share/info/dir

	touch $@

call[[ ipk ]]

]]package