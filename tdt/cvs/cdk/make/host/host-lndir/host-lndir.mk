#
# LIBTOOL
#
package[[ host_lndir

BDEPENDS_${P} = $(host_ccache)

PV_${P} = 1.0.3
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ftp.x.org/pub/individual/util/${PN}-${PV}.tar.bz2
  patch:file://${PN}-no-xorg.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		autoconf && \
		automake && \
		./configure \
			--prefix=$(hostprefix) \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)

	touch $@

call[[ ipk ]]

]]package