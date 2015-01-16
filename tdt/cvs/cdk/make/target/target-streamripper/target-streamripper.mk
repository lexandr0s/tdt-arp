#
# AR-P buildsystem smart Makefile
#
package[[ target_streamripper

BDEPENDS_${P} =  $(target_libogg) $(target_libvorbis) $(target_libmad)

PV_${P} = 1.64.6
PR_${P} = 2

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/${PN}/files/${PN}%20%28current%29/${PV}/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--bindir=/usr/bin \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Records shoutcast-compatible streams
RDEPENDS_${P} = libogg0 libvorbis libmad0
FILES_${P} = /usr/bin/streamripper

call[[ ipkbox ]]

]]package
