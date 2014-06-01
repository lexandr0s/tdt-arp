#
# AR-P buildsystem smart Makefile
#
package[[ target_python_mechanize

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.2.5
PR_${P} = 1

DIR_${P} = $(WORK_${P})/mechanize-${PV}

call[[ base ]]

rule[[
  extract:http://pypi.python.org/packages/source/m/mechanize/mechanize-${PV}.tar.gz
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


DESCRIPTION_${P} = Stateful programmatic web browsing, after Andy Lester's Perl module WWW::Mechanize.
RDEPENDS_${P} = python_core python_robotparser
FILES_${P} = $(PYTHON_DIR)/site-packages/mechanize/*.p*

call[[ ipkbox ]]

]]package
