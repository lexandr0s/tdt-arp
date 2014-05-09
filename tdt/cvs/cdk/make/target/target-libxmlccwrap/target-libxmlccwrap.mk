#
# AR-P buildsystem smart Makefile
#
package[[ target_libxmlccwrap

BDEPENDS_${P} = $(target_libxslt) $(target_libxml2) $(target_gcc_lib) $(target_glibc)

PV_${P} = 0.0.12
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.ant.uni-bremen.de/whomes/rinas/${PN}/download/${PN}-${PV}.tar.gz
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
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = libxmlccwrap is a small C++ wrapper around libxml2 and libxslt
RDEPENDS_${P} += libgcc1 libxml2 libz1 libstdc++6 libc6 libxslt
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
