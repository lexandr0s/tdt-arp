#
# AR-P buildsystem smart Makefile
#
package[[ target_glib2

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_libffi) $(target_libusb)

PV_${P} = 2.34.3
PR_${P} = 1

DIR_${P} = $(workprefix)/glib-${PV}

call[[ base ]]

rule[[
  extract:http://ftp.gnome.org/pub/GNOME/sources/glib/2.34/glib-${PV}.tar.xz
  patch:file://glib-${PV}.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	echo "glib_cv_va_copy=no" > $(DIR_${P})/config.cache
	echo "glib_cv___va_copy=yes" >> $(DIR_${P})/config.cache
	echo "glib_cv_va_val_copy=yes" >> $(DIR_${P})/config.cache
	echo "ac_cv_func_posix_getpwuid_r=yes" >> $(DIR_${P})/config.cache
	echo "ac_cv_func_posix_getgrgid_r=yes" >> $(DIR_${P})/config.cache
	echo "glib_cv_stack_grows=no" >> $(DIR_${P})/config.cache
	echo "glib_cv_uscore=no" >> $(DIR_${P})/config.cache
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--cache-file=config.cache \
			--disable-gtk-doc \
			--with-threads="posix" \
			--enable-static \
			--mandir=/usr/share/man \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libglib
DESCRIPTION_${P} = A general-purpose utility library GLib is a general-purpose \
utility library, which provides many useful data types, macros, type conversions, \
string utilities, file utilities, a main loop abstraction, and so on
RDEPENDS_${P} = libffi6 libz1 libc6
FILES_${P} = \
	/usr/lib/libgio-2.0.so.* \
	/usr/lib/libglib-2.0.so.* \
	/usr/lib/libgmodule-2.0.so.* \
	/usr/lib/libgobject-2.0.so.* \
	/usr/lib/libgthread-2.0.so.* \
	/usr/lib/gio/modules \
	/usr/share/glib-2.0/schemas/gschema.dtd

call[[ ipkbox ]]

]]package