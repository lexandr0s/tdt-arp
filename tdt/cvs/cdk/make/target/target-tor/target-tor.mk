#
# AR-P buildsystem smart Makefile
#
package[[ target_tor

BDEPENDS_${P} = $(target_glibc) $(target_libevent)

PV_${P} = 0.2.4.22
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://www.torproject.org/dist/${PN}-${PV}.tar.gz
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
			--target=$(target) \
			--prefix= \
			--datarootdir=/usr/share \
			--disable-asciidoc \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Tor is a network of virtual tunnels that allows you to improve your privacy and security on the Internet
RDEPENDS_${P} = libevent
FILES_${P} = /

call[[ ipkbox ]]

]]package
