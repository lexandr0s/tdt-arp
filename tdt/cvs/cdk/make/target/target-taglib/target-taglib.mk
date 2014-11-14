#
# AR-P buildsystem smart Makefile
#
package[[ target_taglib

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.9.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://taglib.github.io/releases/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		cmake \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_RELEASE_TYPE=Release . \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = TagLib Audio Meta-Data Library

RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/libtag_c.so.* /usr/lib/libtag.so.*


call[[ ipkbox ]]

]]package
