#
# AR-P buildsystem smart Makefile
#
package[[ target_tinyxml

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.6.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${PN}_2_6_2.tar.gz
  pmove:${PN}:${PN}-${PV}
  patch:file://${PN}${PV}.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
		libtoolize -f -c && \
		$(BUILDENV) \
		 \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install PREFIX=$(PKDIR)/usr LD=sh4-linux-ld
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = tinyxml
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.s*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
