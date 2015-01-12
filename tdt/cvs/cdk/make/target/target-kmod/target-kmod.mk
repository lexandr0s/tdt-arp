#
# AR-P buildsystem smart Makefile
#
package[[ target_kmod

BDEPENDS_${P} = $(target_zlib)

PV_${P} = git
PR_${P} = 1

DESCRIPTION_${P} = Linux kernel module handling.

call[[ base ]]

rule[[
  git://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--libdir=/usr/lib \
			--enable-tools \
			--disable-manpages \
			--with-zlib \
			$(CONFIG_FLAGS_${P}) \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	install -d $(PKDIR)/sbin/
	for tool in insmod rmmod depmod lsmod modinfo modprobe; do \
		ln -sf /usr/bin/kmod $(PKDIR)/sbin/$${tool}; \
	done
	touch $@

call[[ ipk ]]

FILES_kmod = /usr/bin /usr/lib /sbin

call[[ ipkbox ]]

]]package
