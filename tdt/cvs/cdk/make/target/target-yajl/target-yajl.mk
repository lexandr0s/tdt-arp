#
# AR-P buildsystem smart Makefile
#
package[[ target_yajl

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.0.1
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/lloyd/${PN}:r=f4b2b1af87483caac60e50e5352fc783d9b2de2d
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr && \
			sed -i "s/install: all/install: distro/g" Makefile \
		&& \
		$(MAKE) distro
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Yet Another JSON Library

RDEPENDS_${P} = libc6
FILES_${P} = \
/usr/lib/libyajl.* \
/usr/bin/json*

define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
