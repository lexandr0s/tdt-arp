#
# HOST MAKE
#
package[[ host_make

BDEPENDS_${P} = $(host_opkg_meta)

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

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	$(PREPARE_${P})
	cd $(DIR_${P}) && \
		./configure \
			--prefix=$(hostprefix) \
		&& \
		$(MAKE) && \
		$(MAKE) install
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package
