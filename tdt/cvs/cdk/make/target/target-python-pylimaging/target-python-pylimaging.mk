#
# AR-P buildsystem smart Makefile
#
package[[ target_python_pylimaging

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 1.1.7
PR_${P} = 1

PN_${P} = Imaging

call[[ base ]]

rule[[
  extract:http://effbot.org/downloads/Imaging-${PV}.tar.gz
  patch:file://pilimaging-fix-search-paths.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		echo 'JPEG_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' > setup_site.py && \
		echo 'ZLIB_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		echo 'FREETYPE_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		$(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@


DESCRIPTION_${P} = Python Imaging Library
RDEPENDS_${P} = libz1 libfreetype6 python_core libc6 python_lang libjpeg8 python_stringold
FILES_${P} =   $(PYTHON_DIR)/site-packages /usr/bin/*

call[[ ipkbox ]]

]]package
