#
# AR-P buildsystem smart Makefile
#
package[[ target_python_futures

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 2.1.6
PR_${P} = 1

PN_${P} = futures

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/f/${PN}/${PN}-${PV}.tar.gz
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


DESCRIPTION_${P} =   Backport of the concurrent.futures package from Python 3.2.
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = http://pythonhosted.org//futures/
RDEPENDS_${P} = python_core
FILES_${P} = $(PYTHON_DIR)/site-packages/futures/*  $(PYTHON_DIR)/site-packages/concurrent/*

call[[ ipkbox ]]

]]package
