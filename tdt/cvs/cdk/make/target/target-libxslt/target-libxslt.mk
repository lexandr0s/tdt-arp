#
# AR-P buildsystem smart Makefile
#
package[[ target_libxslt

BDEPENDS_${P} = $(target_libxml2)

PV_${P} = 1.1.28
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://xmlsoft.org/sources/${PN}-${PV}.tar.gz
]]rule

CONFIG_FLAGS_${P} = \
	--with-python="$(crossprefix)/bin" \
	--without-crypto \
	--without-debug \
	--without-mem-debug

#	--with-libxml-prefix="$(targetprefix)/usr" \
#	--with-libxml-include-prefix="$(targetprefix)/usr/include" \

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

# 	CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2 -Os" \
# 	CFLAGS="$(TARGET_CFLAGS) -Os" \

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)

	$(call rewrite_config, $(PKDIR)/usr/bin/xslt-config)
	sed -e "/^XSLT_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(PKDIR)/usr/lib/xsltConf.sh
	sed -e "/^XSLT_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(PKDIR)/usr/lib/xsltConf.sh

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = XML stylesheet transformation library
FILES_${P} = \
	/usr/lib/libxslt* \
	/usr/lib/libexslt* \
	$(PYTHON_DIR)/site-packages/libxslt.py

call[[ ipkbox ]]

]]package