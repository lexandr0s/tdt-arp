#
# AR-P buildsystem smart Makefile
#
package[[ target_libbz2

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.0.6
PR_${P} = 1

PN_${P} = bzip2

call[[ base ]]

rule[[
  extract:http://www.bzip.org/${PV}/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		mv Makefile-libbz2_so Makefile && \
		$(MAKE) all CC=$(target)-gcc
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install PREFIX=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  high-quality data compressor
FILES_${P} = /usr/bin/* /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
