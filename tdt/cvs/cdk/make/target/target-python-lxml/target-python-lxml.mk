#
# AR-P buildsystem smart Makefile
#
package[[ target_python_lxml

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 3.3.6
PR_${P} = 1

PN_${P} = lxml

call[[ base ]]

rule[[
  extract:http://pypi.python.org/packages/source/l/${PN}/${PN}-${PV}.tar.gz
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


DESCRIPTION_${P} = Python binding for the libxml2 and libxslt libraries
RDEPENDS_${P} = python_core python_shell
FILES_${P} =  $(PYTHON_DIR)/site-packages/lxml

call[[ ipkbox ]]

]]package
