#
# AR-P buildsystem smart Makefile
#
package[[ target_python_cheetah

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 2.4.4
PR_${P} = 1

DIR_${P} = $(WORK_${P})/Cheetah-${PV}

call[[ base ]]

rule[[
  extract:http://pypi.python.org/packages/source/C/Cheetah/Cheetah-${PV}.tar.gz
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


DESCRIPTION_${P} = Python template engine and code generation tool
RDEPENDS_${P} = libc6 python_pprint python_pickle
FILES_${P} =  /usr/bin/cheetah* $(PYTHON_DIR)/site-packages/Cheetah

call[[ ipkbox ]]

]]package
