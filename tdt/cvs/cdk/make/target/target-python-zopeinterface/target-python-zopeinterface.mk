#
# AR-P buildsystem smart Makefile
#
package[[ target_python_zopeinterface

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 3.5.1
PR_${P} = 1

DIR_${P} = $(workprefix)/zope.interface-${PV}

call[[ base ]]

rule[[
  extract:http://pypi.python.org/packages/source/z/zope.interface/zope.interface-${PV}.tar.gz
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

PACKAGES_${P} = python_zopeinterface
DESCRIPTION_python_zopeinterface =  Interface definitions for Zope products
RDEPENDS_python_zopeinterface = python_core libc6
FILES_python_zopeinterface = \
  $(PYTHON_DIR)/site-packages/zope/interface/common/*.* \
  $(PYTHON_DIR)/site-packages/zope/interface/__init__.* \
  $(PYTHON_DIR)/site-packages/zope/interface/_flatten.* \
  $(PYTHON_DIR)/site-packages/zope/interface/_zope_interface_coptimizations.so \
  $(PYTHON_DIR)/site-packages/zope/interface/adapter.p* \
  $(PYTHON_DIR)/site-packages/zope/interface/advice.* \
  $(PYTHON_DIR)/site-packages/zope/interface/declarations.* \
  $(PYTHON_DIR)/site-packages/zope/interface/document.* \
  $(PYTHON_DIR)/site-packages/zope/interface/exceptions.* \
  $(PYTHON_DIR)/site-packages/zope/interface/interface.* \
  $(PYTHON_DIR)/site-packages/zope/interface/interfaces.* \
  $(PYTHON_DIR)/site-packages/zope/interface/ro.p* \
  $(PYTHON_DIR)/site-packages/zope/interface/verify.p* \
  $(PYTHON_DIR)/site-packages/zope.interface-3.5.1-py2.7-nspkg.pth

call[[ ipkbox ]]

]]package