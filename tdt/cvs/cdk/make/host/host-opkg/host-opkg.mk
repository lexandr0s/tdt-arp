#
# OPKG-HOST
#
package[[ host_opkg

BDEPENDS_${P} = $(host_filesystem)

PV_${P} = 0.2.0
PR_${P} = 1

call[[ base_bare ]]

rule[[
  extract:http://opkg.googlecode.com/files/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}): $(DEPENDS_${P})
	$(PREPARE_${P})
	cd $(DIR_${P}) && \
		./configure \
			--prefix=$(hostprefix) \
		&& \
		$(MAKE) && \
		$(MAKE) install && \
	ln -sf opkg-cl $(hostprefix)/bin/opkg

	install -d $(hostprefix)/usr/lib/opkg
	install -d $(hostprefix)/etc
	( echo "dest hostroot /"; \
	  echo "lists_dir ext /usr/lib/opkg"; \
	  echo "arch $(box_arch) 16"; \
	  echo "arch sh4 10"; \
	  echo "arch all 1"; \
	  echo "src/gz host file://$(ipkhost)"; \
	) > $(${P}_conf)

	touch $@

]]package