#
# AR-P buildsystem smart Makefile
#
package[[ target_tremor

BDEPENDS_${P} = $(target_glibc) $(target_libogg)

PV_${P} = svn
PR_${P} = 1

call[[ base ]]

rule[[
  svn://svn.xiph.org/trunk/Tremor;r=18221
  patch:file://tremor-configure.patch
]]rule

call[[ svn ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libvorbisidec1
DESCRIPTION_${P} = tremor is a fixed point implementation of the vorbis codec.
RDEPENDS_${P} = libogg0 libc6
define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
