#
# IPKG-UTILS
#
package[[ host_ipkg_utils

BDEPENDS_${P} = $(host_filesystem)

PV_${P} = 050831
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.gwdg.de/linux/handhelds/packages/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	install -d $(hostprefix)/bin
	cd $(DIR_${P}) && \
		$(MAKE) all PREFIX=$(hostprefix) && \
		$(MAKE) install PREFIX=$(hostprefix)
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package