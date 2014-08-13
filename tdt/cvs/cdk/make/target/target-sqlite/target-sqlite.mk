#
# AR-P buildsystem smart Makefile
#
package[[ target_sqlite

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 3080500
PR_${P} = 1

DIR_${P} = ${WORK}/${PN}-autoconf-${PV}

call[[ base ]]

rule[[
  extract:http://www.${PN}.org/2014/${PN}-autoconf-${PV}.tar.gz
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
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libsqlite3
DESCRIPTION_${P} = Embeddable SQL database engine \
 Embeddable SQL database engine.
RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_sqlite = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
