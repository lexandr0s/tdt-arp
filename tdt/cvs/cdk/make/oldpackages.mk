#
# EXTRA FONTS
#

DESCRIPTION_fonts_extra = Extra fonts to beautify your box
SRC_URI_fonts_extra = git://gitorious.org/~schpuntik/open-duckbox-project-sh4/tdt-amiko.git
PKGV_fonts_extra = 0.1
SRC_URI_font_valis_enigma = $(SRC_URI_fonts_extra)
PKGV_font_valis_enigma = $(PKGV_fonts_extra)

fonts_extra_file_list = $(subst .ttf,,$(shell ls root/usr/share/fonts/))

# This can be used as multipackaging example
# Remember to replace '-' with '_' in variables and package names

PACKAGES_fonts_extra = $(subst -,_,$(addprefix font_,$(fonts_extra_file_list)))
$(foreach f,$(fonts_extra_file_list), \
 $(eval DESCRIPTION_font_$(subst -,_,$f) = font $f ) \
 $(eval FILES_font_$(subst -,_,$f) = /usr/share/fonts/$f*) \
)

$(DEPDIR)/font-valis-enigma: fonts-extra
	$(start_build)
	$(INSTALL) -d $(PKDIR)/usr/share/fonts
	$(INSTALL) -m 644 root/usr/share/fonts/valis_enigma.ttf $(PKDIR)/usr/share/fonts
	$(toflash_build)
	touch $@

$(DEPDIR)/fonts-extra: $(addsuffix .ttf, $(addprefix root/usr/share/fonts/,$(fonts_extra_file_list)))
	$(start_build)
	$(INSTALL) -d $(PKDIR)/usr/share/fonts
	$(INSTALL) -m 644 $^ $(PKDIR)/usr/share/fonts
	$(extra_build)
	touch $@


#
# parted
#
BEGIN[[
parted
  3.1
  {PN}-{PV}
  extract:http://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.xz
  patch:file://{PN}_{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_parted = "parted"
FILES_parted = \
/usr/lib/libparted-fs-resize.s* \
/usr/lib/libparted.s* \
/usr/sbin/parted

$(DEPDIR)/parted.do_prepare: bootstrap $(DEPENDS_parted)
	$(PREPARE_parted)
	touch $@

$(DEPDIR)/parted.do_compile: $(DEPDIR)/parted.do_prepare
	cd $(DIR_parted) && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-Werror \
			--disable-device-mapper && \
		$(MAKE) all CC=$(target)-gcc STRIP=$(target)-strip
	touch $@

$(DEPDIR)/parted: $(DEPDIR)/parted.do_compile
	$(start_build)
	cd $(DIR_parted) && \
		$(INSTALL_parted)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# gettext
#
BEGIN[[
gettext
  0.18
  {PN}-{PV}
  extract:ftp://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gettext = "gettext"
FILES_gettext = \
*

$(DEPDIR)/gettext.do_prepare: bootstrap $(DEPENDS_gettext)
	$(PREPARE_gettext)
	touch $@

$(DEPDIR)/gettext.do_compile: $(DEPDIR)/gettext.do_prepare
	cd $(DIR_gettext) && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-emacs \
			--without-cvs \
			--disable-java && \
		$(MAKE) all 
	touch $@

$(DEPDIR)/gettext: $(DEPDIR)/gettext.do_compile
	$(start_build)
	cd $(DIR_gettext) && \
		$(INSTALL_gettext)
	$(tocdk_build)
	$(toflash_build)
	touch $@


