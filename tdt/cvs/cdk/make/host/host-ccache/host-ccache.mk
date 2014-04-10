#
# CCACHE
#
package[[ host_ccache

BDEPENDS_${P} = host-opkg-meta

PV_${P} = 3.1.8
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://samba.org/ftp/${PN}/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./configure \
			--build=$(build) \
			--host=$(build) \
			--prefix=$(hostprefix) \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		make install DESTDIR=$(PKDIR)
	install -d $(PKDIR)/ccache-bin
	ln -sf ../bin/ccache $(PKDIR)/ccache-bin/gcc
	ln -sf ../bin/ccache $(PKDIR)/ccache-bin/g++
	ln -sf ../bin/ccache $(PKDIR)/ccache-bin/$(target)-gcc
	ln -sf ../bin/ccache $(PKDIR)/ccache-bin/$(target)-g++
#	ln -sf ../bin/ccache $(PKDIR)/bin/$(target)-gcc
#	ln -sf ../bin/ccache $(PKDIR)/bin/$(target)-g++
	mv $(PKDIR)/ccache-bin $(PKDIR)/$(hostprefix)/
	touch $@

call[[ ipk ]]

]]package