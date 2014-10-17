#
# AR-P buildsystem smart Makefile
#
package[[ target_python_pyasn1

BDEPENDS_${P} = $(target_python_setuptools) $(target_python_pyasn1)

PV_${P} = 0.1.7
PR_${P} = 1

DIR_${P} = $(WORK_${P})/pyasn1-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/p/pyasn1/pyasn1-${PV}.tar.gz
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


DESCRIPTION_${P} =  ASN.1 library for Python
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = http://pyasn1.sourceforge.net/
RDEPENDS_${P} = python_core libc6
FILES_${P} = $(PYTHON_DIR)/site-packages/pyasn1/*

call[[ ipkbox ]]

]]package
