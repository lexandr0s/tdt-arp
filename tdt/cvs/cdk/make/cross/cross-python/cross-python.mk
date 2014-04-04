#
# CCACHE
#
package[[ cross_python

BDEPENDS_${P} = $(cross_filesystem)

PV_${P} = $(PV_target_python)
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.python.org/ftp/python/${PV}/Python-${PV}.tar.bz2
  pmove:Python-${PV}:${PN}-${PV}
  patch:file://python_${PV}.diff
  patch:file://python_${PV}-ctypes-libffi-fix-configure.diff
  patch:file://python_${PV}-pgettext.diff
]]rule

MAKE_FLAGS_${P} = \
	TARGET_OS=$(build) \
	PYTHON_MODULES_INCLUDE="$(crossprefix)/include" \
	PYTHON_MODULES_LIB="$(crossprefix)/lib" \
	HOSTPYTHON=./hostpython \
	HOSTPGEN=./hostpgen \


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		rm -rf config.cache && \
		autoconf && \
		CONFIG_SITE= \
		OPT="$(HOST_CFLAGS)" \
		./configure \
			--without-cxx-main \
			--without-threads \
		&& \
		make python Parser/pgen && \
		mv python ./hostpython && \
		mv Parser/pgen ./hostpgen && \
		make distclean && \
		./configure \
			--prefix=$(crossprefix) \
			--sysconfdir=$(crossprefix)/etc \
			--without-cxx-main \
			--without-threads \
		&& \
		make $(MAKE_FLAGS_${P}) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	cd $(DIR_${P}) && make $(MAKE_FLAGS_${P}) install DESTDIR=$(PKDIR)
	cp $(DIR_${P})/hostpgen $(PKDIR)/$(crossprefix)/bin/pgen
	touch $@

]]package