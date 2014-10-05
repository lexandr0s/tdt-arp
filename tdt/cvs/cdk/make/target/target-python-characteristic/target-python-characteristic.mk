#
# AR-P buildsystem smart Makefile
#
package[[ target_python_characteristic

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.1.0
PR_${P} = 1

DIR_${P} = $(WORK_${P})/characteristic-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/c/characteristic/characteristic-${PV}.tar.gz
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


DESCRIPTION_${P} =  characteristic is an MIT-licensed Python package with class decorators that ease the chores of implementing \
the most common attribute-related object protocols.
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = https://github.com/hynek/characteristic/
RDEPENDS_${P} = python_core libc6
FILES_${P} = $(PYTHON_DIR)/site-packages/characteristic.p*

call[[ ipkbox ]]

]]package
