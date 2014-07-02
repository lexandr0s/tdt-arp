#
# AR-P buildsystem smart Makefile
#
package[[ target_libreadline

BDEPENDS_${P} = $(target_glibc) $(target_ncurses)

PV_${P} = 6.2
PR_${P} = 1

DIR_${P} = ${WORK}/readline-${PV}

call[[ base ]]

rule[[
  extract:ftp://ftp.cwru.edu/pub/bash/readline-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoconf && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	rm -f $(PKDIR)/usr/share/info/dir
	touch $@

call[[ ipk ]]

NAME_${P} = libreadline6
DESCRIPTION_${P} = Library for editing typed command lines \
 The GNU Readline library provides a set of functions for use by \
 applications that allow users to edit command lines as they are typed in. \
 Both Emacs and vi editing modes are available
RDEPENDS_${P} += libncurses5 libc6
FILES_${P} = /usr/lib/*.so*
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
