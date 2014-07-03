

#
# pylimaging
#
BEGIN[[
pylimaging
  1.1.7
  Imaging-{PV}
  extract:http://effbot.org/downloads/Imaging-{PV}.tar.gz
  patch:file://pilimaging-fix-search-paths.patch
;
]]END
NAME_pylimaging = python_imaging
DESCRIPTION_pylimaging =  Python Imaging Library
RDEPENDS_pylimaging = libz1 libfreetype6 python_core libc6 python_lang libjpeg8 python_stringold
FILES_pylimaging = $(PYTHON_DIR)/site-packages /usr/bin/*

$(DEPDIR)/pylimaging: bootstrap python setuptools $(DEPENDS_pylimaging)
	$(PREPARE_pylimaging)
	$(start_build)
	cd $(DIR_pylimaging) && \
		echo 'JPEG_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' > setup_site.py && \
		echo 'ZLIB_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		echo 'FREETYPE_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build && \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr && \
	$(tocdk_build)
	$(toflash_build)
	touch $@




#
# pyusb
#
BEGIN[[
pyusb
  1.0.0a3
  {PN}-{PV}
  extract:http://pypi.python.org/packages/source/p/{PN}/{PN}-{PV}.tar.gz
;
]]END
NAME_pyusb = python_pyusb
DESCRIPTION_pyusb =  PyUSB provides USB access on the Python language
RDEPENDS_pyusb = python_core
FILES_pyusb = \
$(PYTHON_DIR)/site-packages/usb/*

$(DEPDIR)/pyusb.do_prepare: bootstrap setuptools $(DEPENDS_pyusb)
	$(PREPARE_pyusb)
	touch $@

$(DEPDIR)/pyusb.do_compile: $(DEPDIR)/pyusb.do_prepare
	cd $(DIR_pyusb) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyusb: $(DEPDIR)/pyusb.do_compile
	$(start_build)
	cd $(DIR_pyusb) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
	touch $@





#
# mutagen
#
BEGIN[[
mutagen
  1.22
  {PN}-{PV}
  extract:https://mutagen.googlecode.com/files/{PN}-{PV}.tar.gz
;
]]END
NAME_mutagen = python_mutagen
DESCRIPTION_mutagen = Module for manipulating ID3 (v1 + v2) tags in Python
RDEPENDS_mutagen = python_core python_shell
FILES_mutagen = \
  $(PYTHON_DIR)/site-packages/mutagen \
  /usr/bin

$(DEPDIR)/mutagen.do_prepare: bootstrap python setuptools $(DEPENDS_mutagen)
	$(PREPARE_mutagen)
	touch $@

$(DEPDIR)/mutagen.do_compile: $(DEPDIR)/mutagen.do_prepare
	cd $(DIR_mutagen) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/mutagen: $(DEPDIR)/mutagen.do_compile
	$(start_build)
	cd $(DIR_mutagen) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# gdata
#
BEGIN[[
gdata
  2.0.18
  gdata-{PV}
  extract:http://gdata-python-client.googlecode.com/files/gdata-{PV}.tar.gz
;
]]END

NAME_gdata = python_gdata
DESCRIPTION_gdata = Google Data APIs Python Client Library
RDEPENDS_gdata = python_core python_elementtree
FILES_gdata = \
  $(PYTHON_DIR)/site-packages/atom/*.* \
  $(PYTHON_DIR)/site-packages/gdata/*.* \
  $(PYTHON_DIR)/site-packages/gdata/


$(DEPDIR)/gdata.do_prepare: bootstrap setuptools $(DEPENDS_gdata)
	$(PREPARE_gdata)
	touch $@

$(DEPDIR)/gdata.do_compile: $(DEPDIR)/gdata.do_prepare
	cd $(DIR_gdata) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/gdata: $(DEPDIR)/gdata.do_compile
	$(start_build)
	cd $(DIR_gdata) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# lxml
#
BEGIN[[
lxml
  2.2.8
  {PN}-{PV}
  extract:http://launchpad.net/{PN}/2.2/{PV}/+download/{PN}-{PV}.tgz
;
]]END

DESCRIPTION_lxml = "Python binding for the libxml2 and libxslt libraries"
BDEPENDS_lxml = python

FILES_lxml = \
$(PYTHON_DIR)

$(DEPDIR)/lxml.do_prepare: bootstrap $(DEPENDS_lxml)
	$(PREPARE_lxml)
	touch $@

$(DEPDIR)/lxml.do_compile: $(DEPDIR)/lxml.do_prepare
	cd $(DIR_lxml) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config
	touch $@

$(DEPDIR)/lxml: $(DEPDIR)/lxml.do_compile
	$(start_build)
	cd $(DIR_lxml) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(extra_build)
	touch $@



#
# elementtree
#
BEGIN[[
elementtree
  1.2.6-20050316
  {PN}-{PV}
  extract:http://effbot.org/media/downloads/{PN}-{PV}.tar.gz
;
]]END

DESCRIPTION_elementtree = "Provides light-weight components for working with XML"
FILES_elementtree = \
$(PYTHON_DIR)

$(DEPDIR)/elementtree.do_prepare: bootstrap $(DEPENDS_elementtree)
	$(PREPARE_elementtree)
	touch $@

$(DEPDIR)/elementtree.do_compile: $(DEPDIR)/elementtree.do_prepare
	touch $@

$(DEPDIR)/elementtree: $(DEPDIR)/elementtree.do_compile
	$(start_build)
	cd $(DIR_elementtree) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@
