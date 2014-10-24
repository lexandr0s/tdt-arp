#
# AR-P buildsystem smart Makefile
#
package[[ target_python_pycurl

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 7.19.5
PR_${P} = 1

PN_${P} = pycurl

call[[ base ]]

rule[[
  extract:http://pycurl.sourceforge.net/download/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@
call[[ ipk ]]


DESCRIPTION_${P} =   PycURL is a Python interface to libcurl. PycURL can be used to fetch objects \
identified by a URL from a Python program, similar to the urllib Python module.
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = http://pycurl.sourceforge.net/
RDEPENDS_${P} = python_core libc6
FILES_${P} = $(PYTHON_DIR)/site-packages/curl/*  $(PYTHON_DIR)/site-packages/pycurl.so

call[[ ipkbox ]]

]]package
