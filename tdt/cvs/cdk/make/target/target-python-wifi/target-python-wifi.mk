#
# AR-P buildsystem smart Makefile
#
package[[ target_python_wifi

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.5.0
PR_${P} = 1

#DIR_${P} = $(WORK_${P})/Twisted-${PV}

call[[ base ]]

rule[[
  extract:http://freefr.dl.sourceforge.net/project/pythonwifi.berlios/python-wifi-${PV}.tar.bz2
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


DESCRIPTION_${P} = Python WiFi is a Python module that provides read and write access \
	to a wireless network card's capabilities using the Linux Wireless Extensions
RDEPENDS_${P} = python_core python_ctypes python_datetime
FILES_${P} = \
	$(PYTHON_DIR)/site-packages/pythonwifi

call[[ ipkbox ]]

]]package
