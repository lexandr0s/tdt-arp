#
# AR-P buildsystem smart Makefile
#
package[[ target_python_serviceidentity

BDEPENDS_${P} = $(target_python_setuptools) $(target_python_pyopenssl) $(target_python_characteristic) $(target_python_pyasn1modules) $(target_python_pyasn1)

PV_${P} = 1.0.0
PR_${P} = 1

DIR_${P} = $(WORK_${P})/service_identity-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/s/service_identity/service_identity-${PV}.tar.gz
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


DESCRIPTION_${P} =  Service Identity Verification for pyOpenSSL
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = https://github.com/pyca/service_identity
RDEPENDS_${P} = python_characteristic python_pyasn1modules
FILES_${P} = \
$(PYTHON_DIR)/site-packages/service_identity/*

call[[ ipkbox ]]

]]package
