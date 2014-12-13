#
# ZLIB
#
package[[ target_zlib

BDEPENDS_${P} = $(target_binutils)

PV_${P} = 1.2.8
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://zlib.net/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--shared \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libz1
DESCRIPTION_${P} = Zlib Compression Library Zlib is a general-purpose, patent-free, lossless data compression library \
which is used by many different programs.
FILES_${P} = /usr/lib/libz.so*

call[[ ipkbox ]]

]]package
