#
# AR-P buildsystem smart Makefile
#
package[[ target_python_singledispatch

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 3.4.0.3
PR_${P} = 1

DIR_${P} = $(WORK_${P})/singledispatch-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/s/singledispatch/singledispatch-${PV}.tar.gz
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


DESCRIPTION_${P} = This library brings functools.singledispatch from Python 3.4 to Python 2.6-3.3.
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} =  http://docs.python.org/3/library/functools.html#functools.singledispatch
RDEPENDS_${P} = python_core libc6
FILES_${P} = \
$(PYTHON_DIR)/site-packages/singledispatch.p* \
$(PYTHON_DIR)/site-packages/singledispatch_helpers.p*

call[[ ipkbox ]]

]]package
