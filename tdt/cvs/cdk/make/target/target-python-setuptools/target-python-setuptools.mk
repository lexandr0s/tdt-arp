#
# AR-P buildsystem smart Makefile
#
package[[ target_python_setuptools

BDEPENDS_${P} = $(target_python)

PV_${P} = 0.6c11
PR_${P} = 2
PN_${P} = setuptools

call[[ base ]]

rule[[
  extract:http://pypi.python.org/packages/source/s/${PN}/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = setuptools
FILES_${P} = \
	$(PYTHON_DIR)/site-packages/*.py \
	$(PYTHON_DIR)/site-packages/*.pyo \
	$(PYTHON_DIR)/site-packages/setuptools/*.py \
	$(PYTHON_DIR)/site-packages/setuptools/*.pyo \
	$(PYTHON_DIR)/site-packages/setuptools/command/*.py \
	$(PYTHON_DIR)/site-packages/setuptools/command/*.pyo

call[[ ipkbox ]]

]]package