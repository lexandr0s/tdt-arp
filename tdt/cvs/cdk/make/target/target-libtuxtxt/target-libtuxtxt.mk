#
# AR-P buildsystem smart Makefile
#
package[[ target_libtuxtxt

BDEPENDS_${P} = $(target_freetype) $(target_zlib) $(target_driver)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://git.code.sf.net/p/openpli/tuxtxt.git:sub=libtuxtxt
  patch:file://libtuxtxt-1.0-fix_dbox_headers.diff
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		libtoolize --force && \
		automake --foreign --add-missing && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libtuxtxt0
DESCRIPTION_${P} = tuxbox libtuxtxt
RDEPENDS_${P} = libfreetype6 libz1
FILES_${P} = /usr/lib/libtuxtxt*

call[[ ipkbox ]]

]]package