#
# AR-P buildsystem smart Makefile
#
package[[ target_libxml2

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 2.9.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://xmlsoft.org/sources/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--with-python=$(crossprefix)/bin \
			--without-c14n \
			--without-debug \
			--without-mem-debug \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)

	$(call rewrite_config, $(PKDIR)/usr/bin/xml2-config)
	sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(PKDIR)/usr/lib/xml2Conf.sh
	sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(PKDIR)/usr/lib/xml2Conf.sh

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = XML C Parser Library and Toolkit \
 The XML Parser Library allows for manipulation of XML files.  Libxml2 \
 exports Push and Pull type parser interfaces for both XML and HTML.  It \
 can do DTD validation at parse time, on a parsed document instance or \
 with an arbitrary DTD.  Libxml2 includes complete XPath, XPointer and \
 Xinclude implementations.  It also has a SAX like interface, which is \
 designed to be compatible with Expat.
RDEPENDS_${P} = libz1 libc6
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_${P} = /usr/bin/xmlcatalog /usr/bin/xmllint /usr/lib/libxml2.s*

call[[ ipkbox ]]

]]package
