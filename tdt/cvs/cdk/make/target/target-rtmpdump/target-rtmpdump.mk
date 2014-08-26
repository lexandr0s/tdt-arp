#
# AR-P buildsystem smart Makefile
#
package[[ target_rtmpdump

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_openssl)

PV_${P} = 0.10.2
PR_${P} = 1

call[[ base ]]

rule[[
  git://git.ffmpeg.org/${PN}.git
]]rule

MAKE_FLAGS_${P} = \
	CROSS_COMPILE=$(target)- \
	prefix=/usr

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		libtoolize -f -c && \
		make $(MAKE_FLAGS_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make $(MAKE_FLAGS_${P}) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = librtmp1
DESCRIPTION_${P} = librtmp Real-Time Messaging Protocol API
RDEPENDS_${P} = libssl1 libz1 libc6 libcrypto1
define postinst_rtmpdump
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/librtmp.s*

call[[ ipkbox ]]

]]package
