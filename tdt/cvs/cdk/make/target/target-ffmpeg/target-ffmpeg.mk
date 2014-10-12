#
# AR-P buildsystem smart Makefile
#
package[[ target_ffmpeg

BDEPENDS_${P} = $(target_glibc) $(target_rtmpdump)

PV_${P} = 2.1.3
PR_${P} = 1

DESCRIPTION_${P} = ffmpeg

call[[ base ]]

rule[[
  extract:http://ffmpeg.org/releases/${PN}-${PV}.tar.bz2
  patch:file://${PN}-${PV}.patch
]]rule

CONFIG_FLAGS_${P} = \
		--disable-static \
		--enable-shared \
		--disable-runtime-cpudetect \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-doc \
		--disable-htmlpages \
		--disable-manpages \
		--disable-podpages \
		--disable-txtpages \
		--disable-asm \
		--disable-altivec \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmxext \
		--disable-sse \
		--disable-sse2 \
		--disable-sse3 \
		--disable-ssse3 \
		--disable-sse4 \
		--disable-sse42 \
		--disable-avx \
		--disable-fma4 \
		--disable-armv5te \
		--disable-armv6 \
		--disable-armv6t2 \
		--disable-vfp \
		--disable-neon \
		--disable-vis \
		--disable-inline-asm \
		--disable-yasm \
		--disable-mips32r2 \
		--disable-mipsdspr1 \
		--disable-mipsdspr2 \
		--disable-mipsfpu \
		--disable-fast-unaligned \
		--disable-muxers \
		--enable-muxer=flac \
		--enable-muxer=mp3 \
		--enable-muxer=h261 \
		--enable-muxer=h263 \
		--enable-muxer=h264 \
		--enable-muxer=image2 \
		--enable-muxer=mpeg1video \
		--enable-muxer=mpeg2video \
		--enable-muxer=ogg \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=mpeg1video \
		--enable-encoder=mpeg2video \
		--enable-encoder=png \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=dvbsub \
		--enable-decoder=flac \
		--enable-decoder=pcm_s16le \
		--enable-decoder=flv \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h263p \
		--enable-decoder=h264 \
		--enable-decoder=h264_crystalhd \
		--enable-decoder=iff_byterun1 \
		--enable-decoder=mjpeg \
		--enable-decoder=mp3 \
		--enable-decoder=mpegvideo \
		--enable-decoder=mpeg1video \
		--enable-decoder=mpeg2video \
		--enable-decoder=mpeg2video_crystalhd \
		--enable-decoder=mpeg4 \
		--enable-decoder=mpeg4_crystalhd \
		--enable-decoder=png \
		--enable-decoder=theora \
		--enable-decoder=vorbis \
		--enable-parser=mjpeg \
		--enable-demuxer=mjpeg \
		--enable-demuxer=wav \
		--enable-demuxer=hls \
		--enable-protocol=file \
		--enable-protocol=hls \
		--enable-protocol=udp \
		--disable-indevs \
		--disable-outdevs \
		--enable-avresample \
		--enable-pthreads \
		--enable-bzlib \
		--disable-zlib \
		--disable-bsfs \
		--enable-librtmp \
		--pkg-config="pkg-config" \
		--disable-parser=hevc \
		--enable-cross-compile \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--disable-debug \
		--extra-cflags="-fno-strict-aliasing" \
		--enable-stripping


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

RDEPENDS_ffmpeg = librtmp1
FILES_ffmpeg = /usr/lib/*.so* /usr/bin/ffmpeg

call[[ ipkbox ]]

]]package
