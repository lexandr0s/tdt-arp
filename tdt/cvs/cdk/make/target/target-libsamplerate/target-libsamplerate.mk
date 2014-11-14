#
# AR-P buildsystem smart Makefile
#
package[[ target_libsamplerate

BDEPENDS_${P} = $(target_glibc) $(target_libogg)

PV_${P} = 0.1.8
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.mega-nerd.com/SRC/${PN}-${PV}.tar.gz
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

DESCRIPTION_${P} = Audio Sample Rate Conversion library
NAME_${P} = libsamplerate0
RDEPENDS_${P} = libsndfile1 libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.* /usr/bin/sndfile*

call[[ ipkbox ]]

]]package
