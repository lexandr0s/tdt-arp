#
# AR-P buildsystem smart Makefile
#
package[[ target_ffmpeg

BDEPENDS_${P} = $(target_glibc) $(target_libbluray) $(target_rtmpdump)

PV_${P} = 2.3.2
PR_${P} = 1

DESCRIPTION_${P} = ffmpeg

call[[ base ]]

rule[[
  extract:http://www.{PN}.org/releases/{PN}-{PV}.tar.gz
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
		--disable-xop \
		--disable-fma3 \
		--disable-fma4 \
		--disable-avx2 \
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
		--enable-muxer=ogg \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=mpeg1video \
		--enable-encoder=png \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=aac_latm \
		--enable-decoder=adpcm_4xm \
		--enable-decoder=adpcm_adx \
		--enable-decoder=adpcm_afc \
		--enable-decoder=adpcm_ct \
		--enable-decoder=adpcm_dtk \
		--enable-decoder=adpcm_ea \
		--enable-decoder=adpcm_ea_maxis_xa \
		--enable-decoder=adpcm_ea_r1 \
		--enable-decoder=adpcm_ea_r2 \
		--enable-decoder=adpcm_ea_r3 \
		--enable-decoder=adpcm_ea_xas \
		--enable-decoder=adpcm_g722 \
		--enable-decoder=adpcm_g726 \
		--enable-decoder=adpcm_g726le \
		--enable-decoder=adpcm_ima_amv \
		--enable-decoder=adpcm_ima_apc \
		--enable-decoder=adpcm_ima_dk3 \
		--enable-decoder=adpcm_ima_dk4 \
		--enable-decoder=adpcm_ima_ea_eacs \
		--enable-decoder=adpcm_ima_ea_sead \
		--enable-decoder=adpcm_ima_iss \
		--enable-decoder=adpcm_ima_oki \
		--enable-decoder=adpcm_ima_qt \
		--enable-decoder=adpcm_ima_rad \
		--enable-decoder=adpcm_ima_smjpeg \
		--enable-decoder=adpcm_ima_wav \
		--enable-decoder=adpcm_ima_ws \
		--enable-decoder=adpcm_ms \
		--enable-decoder=adpcm_sbpro_2 \
		--enable-decoder=adpcm_sbpro_3 \
		--enable-decoder=adpcm_sbpro_4 \
		--enable-decoder=adpcm_swf \
		--enable-decoder=adpcm_thp \
		--enable-decoder=adpcm_vima \
		--enable-decoder=adpcm_xa \
		--enable-decoder=adpcm_yamaha \
		--enable-decoder=alac \
		--enable-decoder=ape \
		--enable-decoder=atrac1 \
		--enable-decoder=atrac3 \
		--enable-decoder=atrac3p \
		--enable-decoder=binkaudio_dct \
		--enable-decoder=binkaudio_rdft \
		--enable-decoder=bmv_audio \
		--enable-decoder=comfortnoise \
		--enable-decoder=cook \
		--enable-decoder=dsd_lsbf \
		--enable-decoder=dsd_lsbf_planar \
		--enable-decoder=dsd_msbf \
		--enable-decoder=dsd_msbf_planar \
		--enable-decoder=dsicinaudio \
		--enable-decoder=eac3 \
		--enable-decoder=evrc \
		--enable-decoder=flac \
		--enable-decoder=g723_1 \
		--enable-decoder=g729 \
		--enable-decoder=gsm \
		--enable-decoder=gsm_ms \
		--enable-decoder=iac \
		--enable-decoder=imc \
		--enable-decoder=interplay_dpcm \
		--enable-decoder=mace3 \
		--enable-decoder=mace6 \
		--enable-decoder=metasound \
		--enable-decoder=mlp \
		--enable-decoder=mp1 \
		--enable-decoder=mp3adu \
		--enable-decoder=mp3on4 \
		--enable-decoder=nellymoser \
		--enable-decoder=opus \
		--enable-decoder=paf_audio \
		--enable-decoder=pcm_alaw \
		--enable-decoder=pcm_bluray \
		--enable-decoder=pcm_dvd \
		--enable-decoder=pcm_f32be \
		--enable-decoder=pcm_f32le \
		--enable-decoder=pcm_f64be \
		--enable-decoder=pcm_f64le \
		--enable-decoder=pcm_lxf \
		--enable-decoder=pcm_mulaw \
		--enable-decoder=pcm_s16be \
		--enable-decoder=pcm_s16be_planar \
		--enable-decoder=pcm_s16le \
		--enable-decoder=pcm_s16le_planar \
		--enable-decoder=pcm_s24be \
		--enable-decoder=pcm_s24daud \
		--enable-decoder=pcm_s24le \
		--enable-decoder=pcm_s24le_planar \
		--enable-decoder=pcm_s32be \
		--enable-decoder=pcm_s32le \
		--enable-decoder=pcm_s32le_planar \
		--enable-decoder=pcm_s8 \
		--enable-decoder=pcm_s8_planar \
		--enable-decoder=pcm_u16be \
		--enable-decoder=pcm_u16le \
		--enable-decoder=pcm_u24be \
		--enable-decoder=pcm_u24le \
		--enable-decoder=pcm_u32be \
		--enable-decoder=pcm_u32le \
		--enable-decoder=pcm_u8 \
		--enable-decoder=pcm_zork \
		--enable-decoder=qcelp \
		--enable-decoder=qdm2 \
		--enable-decoder=ra_144 \
		--enable-decoder=ra_288 \
		--enable-decoder=ralf \
		--enable-decoder=roq_dpcm \
		--enable-decoder=s302m \
		--enable-decoder=shorten \
		--enable-decoder=sipr \
		--enable-decoder=sol_dpcm \
		--enable-decoder=sonic \
		--enable-decoder=tak \
		--enable-decoder=truehd \
		--enable-decoder=truespeech \
		--enable-decoder=tta \
		--enable-decoder=twinvq \
		--enable-decoder=vima \
		--enable-decoder=vmdaudio \
		--enable-decoder=vorbis \
		--enable-decoder=wavpack \
		--enable-decoder=wmalossless \
		--enable-decoder=wmapro \
		--enable-decoder=wmav1 \
		--enable-decoder=wmav2 \
		--enable-decoder=wmavoice \
		--enable-decoder=xan_dpcm \
		--enable-demuxer=mjpeg \
		--enable-demuxer=wav \
		--enable-demuxer=hls \
		--enable-protocol=file \
		--enable-protocol=hls \
		--enable-protocol=udp \
		--disable-indevs \
		--disable-outdevs \
		--enable-avresample \
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
		--disable-debug


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

RDEPENDS_ffmpeg = libass librtmp1
FILES_ffmpeg = /usr/lib/*.so* /usr/bin/ffmpeg

call[[ ipkbox ]]

]]package
