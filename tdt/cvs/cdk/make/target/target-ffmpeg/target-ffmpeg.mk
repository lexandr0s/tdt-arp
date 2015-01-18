#
# AR-P buildsystem smart Makefile
#
package[[ target_ffmpeg

BDEPENDS_${P} = $(target_glibc) $(target_libbluray) $(target_rtmpdump)

PV_${P} = 2.5.2
PR_${P} = 1

DESCRIPTION_${P} = ffmpeg

call[[ base ]]

rule[[
  extract:http://www.${PN}.org/releases/${PN}-${PV}.tar.gz
  patch:file://${PN}.patch
]]rule

CONFIG_FLAGS_${P} = \
		--disable-static \
		--enable-shared \
		--disable-runtime-cpudetect \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-doc \
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
		--disable-inline-asm \
		--disable-yasm \
		--disable-mips32r2 \
		--disable-mipsdspr1 \
		--disable-mipsdspr2 \
		--disable-mipsfpu \
		--disable-fast-unaligned \
		--disable-muxers \
		--disable-encoders \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=aac_latm \
		--enable-decoder=adpcm_ct \
		--enable-decoder=adpcm_g722 \
		--enable-decoder=adpcm_g726 \
		--enable-decoder=adpcm_g726le \
		--enable-decoder=adpcm_ima_amv \
		--enable-decoder=adpcm_ima_oki \
		--enable-decoder=adpcm_ima_qt \
		--enable-decoder=adpcm_ima_rad \
		--enable-decoder=adpcm_ima_wav \
		--enable-decoder=adpcm_ms \
		--enable-decoder=adpcm_sbpro_2 \
		--enable-decoder=adpcm_sbpro_3 \
		--enable-decoder=adpcm_sbpro_4 \
		--enable-decoder=adpcm_swf \
		--enable-decoder=adpcm_yamaha \
		--enable-decoder=alac \
		--enable-decoder=ape \
		--enable-decoder=atrac1 \
		--enable-decoder=atrac3 \
		--enable-decoder=atrac3p \
		--enable-decoder=cook \
		--enable-decoder=dsd_lsbf \
		--enable-decoder=dsd_lsbf_planar \
		--enable-decoder=dsd_msbf \
		--enable-decoder=dsd_msbf_planar \
		--enable-decoder=eac3 \
		--enable-decoder=evrc \
		--enable-decoder=flac \
		--enable-decoder=g723_1 \
		--enable-decoder=g729 \
		--enable-decoder=iac \
		--enable-decoder=imc \
		--enable-decoder=mace3 \
		--enable-decoder=mace6 \
		--enable-decoder=metasound \
		--enable-decoder=mlp \
		--enable-decoder=mp1 \
		--enable-decoder=mp3adu \
		--enable-decoder=mp3on4 \
		--enable-decoder=nellymoser \
		--enable-decoder=opus \
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
		--enable-decoder=s302m \
		--enable-decoder=shorten \
		--enable-decoder=sipr \
		--enable-decoder=sonic \
		--enable-decoder=tak \
		--enable-decoder=truehd \
		--enable-decoder=truespeech \
		--enable-decoder=tta \
		--enable-decoder=vorbis \
		--enable-decoder=wavpack \
		--enable-decoder=wmalossless \
		--enable-decoder=wmapro \
		--enable-decoder=wmav1 \
		--enable-decoder=wmav2 \
		--enable-decoder=wmavoice \
		--disable-demuxer=adp \
		--disable-demuxer=adx \
		--disable-demuxer=afc \
		--disable-demuxer=anm \
		--disable-demuxer=apc \
		--disable-demuxer=apng \
		--disable-demuxer=ast \
		--disable-demuxer=avs \
		--disable-demuxer=bethsoftvid \
		--disable-demuxer=bfi \
		--disable-demuxer=bink \
		--disable-demuxer=bmv \
		--disable-demuxer=brstm \
		--disable-demuxer=c93 \
		--disable-demuxer=cdg \
		--disable-demuxer=dsicin \
		--disable-demuxer=dfa \
		--disable-demuxer=dxa \
		--disable-demuxer=ea \
		--disable-demuxer=ea_cdata \
		--disable-demuxer=frm \
		--disable-demuxer=gif \
		--disable-demuxer=gsm \
		--disable-demuxer=gxf \
		--disable-demuxer=hnm \
		--disable-demuxer=ico \
		--disable-demuxer=ilbc \
		--disable-demuxer=iss \
		--disable-demuxer=jv \
		--disable-demuxer=mm \
		--disable-demuxer=paf \
		--disable-demuxer=pva \
		--disable-demuxer=qcp \
		--disable-demuxer=redspark \
		--disable-demuxer=rl2 \
		--disable-demuxer=roq \
		--disable-demuxer=rsd \
		--disable-demuxer=rso \
		--disable-demuxer=siff \
		--disable-demuxer=smjpeg \
		--disable-demuxer=smush \
		--disable-demuxer=sol \
		--disable-demuxer=thp \
		--disable-demuxer=tiertexseq \
		--disable-demuxer=tmv \
		--disable-demuxer=tty \
		--disable-demuxer=txd \
		--disable-demuxer=vqf \
		--disable-demuxer=wsaud \
		--disable-demuxer=wsvqa \
		--disable-demuxer=xa \
		--disable-demuxer=xbin \
		--disable-demuxer=yop \
		--disable-filters \
		--enable-libbluray \
		--enable-protocol=bluray \
		--disable-protocol=data \
		--disable-protocol=icecast \
		--disable-protocol=md5 \
		--disable-protocol=pipe \
		--disable-protocol=unix \
		--enable-nonfree \
		--enable-openssl \
		--disable-indevs \
		--disable-outdevs \
		--enable-bzlib \
		--disable-zlib \
		--disable-bsfs \
		--enable-librtmp \
		--pkg-config="pkg-config" \
		--enable-cross-compile \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--disable-debug \
		--enable-pthreads \
		--prefix=/usr \
		--shlibdir=/usr/lib


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

RDEPENDS_ffmpeg = librtmp1 libbluray
FILES_ffmpeg = /usr/lib/*.so.* /usr/bin/ffmpeg

call[[ ipkbox ]]

]]package
