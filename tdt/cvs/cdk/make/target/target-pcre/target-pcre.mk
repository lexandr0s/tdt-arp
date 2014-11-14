#
# AR-P buildsystem smart Makefile
#
package[[ target_pcre

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 8.36
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PV}.tar.bz2
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
			--prefix=/usr \
			--enable-utf8 \
			--enable-unicode-properties \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	sed -e "s,^prefix=,prefix=$(targetprefix)," < pcre-config > $(crossprefix)/bin/pcre-config && \
	chmod 755 $(crossprefix)/bin/pcre-config && \
	$(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libpcre
DESCRIPTION_${P} = Perl-compatible regular expression library
RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.* \
/usr/bin/pcre*

call[[ ipkbox ]]

]]package
