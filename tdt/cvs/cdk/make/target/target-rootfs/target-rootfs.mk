#
# AR-P buildsystem smart Makefile
#
package[[ target_rootfs

BDEPENDS_${P} = \
$(target_sysvinit) $(target_devinit) $(target_udev) $(target_udev_rules) $(target_initscripts) $(target_update_rcd) $(target_busybox) $(target_vsftpd) $(target_base_passwd) $(target_base_files) $(target_netbase) $(target_opkg) $(target_distro_feed_configs)  $(target_zlib) $(target_libbz2) $(target_glibc) $(target_gcc_lib) $(target_bootelf) $(target_firmware) $(target_ustslave) $(target_driver) $(target_bootlogo) $(target_showiframe) $(target_stfbcontrol) $(target_lirc) $(target_fp_control) $(target_tuxbox_configs) $(target_ethtool) $(target_enigma2)

PV_${P} = 0.1
PR_${P} = 6

RM_WORK_${P} = $(false)
call[[ base ]]
#overwrite workdir
WORK_${P} = $(prefix)/release
DIR_${P} = $(WORK_${P})

call[[ base_do_prepare ]]
opkg_rootfs := opkg -f $(prefix)/opkg-box.conf -o $(DIR_${P})

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	( echo "dest root /"; \
	  echo "arch $(box_arch) 16"; \
	  echo "arch sh4 10"; \
	  echo "arch all 1"; \
	  echo "src/gz box file://$(ipkbox)"; \
	) > $(prefix)/opkg-box.conf

	cd $(ipkbox) && \
		/usr/bin/python $(hostprefix)/bin/ipkg-make-index . > Packages && \
		cat Packages | gzip > Packages.gz
	install -d $(DIR_${P})/usr/lib/opkg

	export OPKG_OFFLINE_ROOT=$(DIR_${P}) && \
	$(opkg_rootfs) update && \
	$(opkg_rootfs) install --force-postinstall $(opkg_my_list)
#	add version
	echo "version=OpenAR-P_`date +%d-%m-%y-%T`_git-`git rev-list --count HEAD`" > $(DIR_${P})/etc/image-version
	echo "----------------------------------------------------------" >>          $(DIR_${P})/etc/image-version
	echo "----------------------------------------------------------" >>          $(DIR_${P})/etc/image-version
	cat $(buildprefix)/.config |grep -v '^#' |tr ' ' '\n' >>                      $(DIR_${P})/etc/image-version
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

# helps to fill DEPENDS list
$(TARGET_${P}).print_depends:
#	catch cat exitstatus and see stderr
	@cd $(ipkorigin) && cat $(addsuffix .origin,$(opkg_my_list)) 2>&1 |uniq

# some packages are installed due to rdepends of other ones
# we want to see all the installed packages and rebuild rootfs when any of them changes
$(TARGET_${P}).print_depends_all: $(TARGET_${P})
	set -e; \
	list=`$(opkg_rootfs) list-installed | cut -d ' ' -f 1`; \
	for x in $${list}; do \
		cat $(ipkorigin)/$${x}.origin || true; \
	done

# core system libraries, binaries and scripts
opkg_my_list = \
	sysvinit \
	devinit \
	udev \
	udev-rules \
	initscripts \
	update-rc.d \
	busybox \
	vsftpd \
	base-passwd \
	base-files \
	netbase \
	opkg \
	distro-feed-configs \
	libz1 \
	libbz2 \
	libc6 \
	libgcc1

# kernel with firmware and modules
opkg_my_list += \
	boot-elf \
	firmware \
	ustslave \
	linux-kernel \
	kernel-module-avs \
	kernel-module-bpamem \
	kernel-module-cec \
	kernel-module-compcache \
	kernel-module-cpu-frequ \
	kernel-module-e2-proc \
	kernel-module-encrypt \
	kernel-module-frontcontroller \
	kernel-module-frontends \
	kernel-module-multicom \
	kernel-module-player2 \
	kernel-module-ptinp \
	kernel-module-simu-button \
	kernel-module-smartcard \
	kernel-module-stgfb

# specific box tools
opkg_my_list += \
	bootlogo \
	showiframe \
	stfbcontrol \
	lirc \
	fp-control

# enigma2
opkg_my_list += \
	config-satellites \
	config-cables \
	config-terrestrial \
	config-timezone \
	ethtool \
	enigma2

]]package
