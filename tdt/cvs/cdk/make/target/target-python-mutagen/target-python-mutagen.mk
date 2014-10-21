#
# AR-P buildsystem smart Makefile
#
package[[ target_python_mutagen

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 1.25.1
PR_${P} = 1

PN_${P} = mutagen

call[[ base ]]

rule[[
  extract:https://bitbucket.org/lazka/mutagen/downloads/${PN}-${PV}.tar.gz
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


DESCRIPTION_${P} = Module for manipulating ID3 (v1 + v2) tags in Python
RDEPENDS_${P} = python_core python_shell
FILES_${P} =  $(PYTHON_DIR)/site-packages/mutagen  /usr/bin

call[[ ipkbox ]]

]]package
