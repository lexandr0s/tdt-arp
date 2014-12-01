#
# AR-P buildsystem smart Makefile
#
package[[ target_livestreamer

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 1.10.2
PR_${P} = 1

DIR_${P} = $(WORK_${P})/livestreamer-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/l/livestreamer/livestreamer-${PV}.tar.gz
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


DESCRIPTION_${P} = Livestreamer is command-line utility that extracts streams from various services and pipes them into a video player of choice.
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = http://livestreamer.tanuki.se/
RDEPENDS_${P} = python_core python_requests
FILES_${P} = \
$(PYTHON_DIR)/site-packages/livestreamer/*

call[[ ipkbox ]]

]]package
