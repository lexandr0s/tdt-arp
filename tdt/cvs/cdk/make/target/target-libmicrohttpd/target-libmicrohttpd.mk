#
# AR-P buildsystem smart Makefile
#
package[[ target_libmicrohttpd

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.9.37
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ftp.halifax.rwth-aachen.de/gnu/${PN}/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
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

DESCRIPTION_${P} = library for embedding an HTTP(S) server into C applications
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
