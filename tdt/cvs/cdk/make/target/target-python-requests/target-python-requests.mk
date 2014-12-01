#
# AR-P buildsystem smart Makefile
#
package[[ target_python_requests

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 2.4.1
PR_${P} = 2

DIR_${P} = $(WORK_${P})/requests-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/r/requests/requests-${PV}.tar.gz
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


DESCRIPTION_${P} =  Python HTTP for Humans
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} =  http://python-requests.org
RDEPENDS_${P} = python_core python_email
FILES_${P} = \
$(PYTHON_DIR)/site-packages/requests/*

call[[ ipkbox ]]

]]package
