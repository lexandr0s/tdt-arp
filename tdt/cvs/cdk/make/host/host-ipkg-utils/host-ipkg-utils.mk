#
# IPKG-UTILS
#
package[[ host_ipkg_utils

BDEPENDS_${P} = $(host_filesystem)

PV_${P} = 050831
PR_${P} = 1

call[[ base_bare ]]

rule[[
  extract:ftp://ftp.gwdg.de/linux/handhelds/packages/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

$(TARGET_${P}): $(DEPENDS_${P})
	$(PREPARE_${P})
	cd $(DIR_${P}) && \
		$(MAKE) all PREFIX=$(hostprefix) && \
		$(MAKE) install PREFIX=$(hostprefix)

	touch $@

]]package