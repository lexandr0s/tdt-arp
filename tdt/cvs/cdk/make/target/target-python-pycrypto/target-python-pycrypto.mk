#
# AR-P buildsystem smart Makefile
#
package[[ target_python_pycrypto

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 2.5
PR_${P} = 1

DIR_${P} = $(WORK_${P})/pycrypto-${PV}

call[[ base ]]

rule[[
  extract:http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-${PV}.tar.gz
  patch:file://${PN}-no-usr-include.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@

call[[ ipk ]]


DESCRIPTION_${P} =  A collection of cryptographic algorithms and protocols
RDEPENDS_${P} = python_core libc6
FILES_${P} = \
$(PYTHON_DIR)/site-packages/Crypto/*

call[[ ipkbox ]]

]]package
