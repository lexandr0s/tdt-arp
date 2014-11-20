#
# AR-P buildsystem smart Makefile
#
package[[ target_python_pyusb

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 1.0.0b2
PR_${P} = 1

DIR_${P} = $(WORK_${P})/pyusb-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/p/pyusb/pyusb-${PV}.tar.gz
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

DESCRIPTION_${P} = PyUSB aims to be an easy to use Python module to access USB devices. PyUSB relies on a native system library for USB access.\
Currently, it works out of the box with libusb 0.1, libusb 1.0, libusbx, libusb-win32 and OpenUSB, and works with any PyUSB version starting at \
2.4, including Python 3 releases.
LICENSE_${P} = Take the official web page
HOMEPAGE_${P} = http://walac.github.io/pyusb/
RDEPENDS_${P} = python_core libc6 libusb-1.0
FILES_${P} = $(PYTHON_DIR)/site-packages/usb/*

call[[ ipkbox ]]

]]package
