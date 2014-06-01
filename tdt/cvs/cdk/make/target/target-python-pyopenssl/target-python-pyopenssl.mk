#
# AR-P buildsystem smart Makefile
#
package[[ target_python_pyopenssl

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.13
PR_${P} = 1

DIR_${P} = $(WORK_${P})/pyOpenSSL-${PV}

call[[ base ]]

rule[[
  extract:http://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-${PV}.tar.gz
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


PACKAGES_${P} = python_pyopenssl python_pyopenssl_tests
DESCRIPTION_${P} = Simple Python wrapper around the OpenSSL library

RDEPENDS_python_pyopenssl = python_threading libssl1 libcrypto1 libc6
FILES_python_pyopenssl = \
  $(PYTHON_DIR)/site-packages/OpenSSL/*p* \
  $(PYTHON_DIR)/site-packages/OpenSSL/*so

RDEPENDS_python_pyopenssl_tests = python_pyopenssl
FILES_python_pyopenssl_tests = $(PYTHON_DIR)/site-packages/OpenSSL/test

call[[ ipkbox ]]

]]package
