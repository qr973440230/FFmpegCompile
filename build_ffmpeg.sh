#!/bin/bash
NDK=/home/qr/ndk/android-ndk-r20-linux-x86_64/android-ndk-r20
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64/
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot

API=16
API64=21

function build_android
{
echo "Compiling FFmpeg for $CPU"
./configure \
	${COMMON_OPTIONS} \
	${EXTRA_OPTIONS} \
    	--prefix=$PREFIX \
    	--cross-prefix=$CROSS_PREFIX \
    	--arch=$ARCH \
    	--cpu=$CPU \
    	--cc=$CC \
    	--cxx=$CXX \
    	--sysroot=$SYSROOT \
    	--extra-cflags="$COMMON_CFLAGS $EXTRA_CFLAGS" \
    	--extra-ldflags="$COMMON_LDFLAGS $EXTRA_LDFLAGS"

make clean
make -j4
make install
echo "The Compilation of FFmpeg for $CPU is completed"
}

#许可证选项
COMMON_OPTIONS="$COMMON_OPTIONS --enable-gpl"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-version3"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-nonfree"

#配置选项
COMMON_OPTIONS="$COMMON_OPTIONS --disable-static"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-shared"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-small"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-runtime-cpudetect"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-gray"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-swscale-alpha"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-all"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-autodetect"

#程序选项
COMMON_OPTIONS="$COMMON_OPTIONS --disable-programs"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffmpeg"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffplay"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffprobe"

#文档选项
COMMON_OPTIONS="$COMMON_OPTIONS --disable-doc"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-htmlpages"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-manpages"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-podpages"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-txtpages"

#组建选项
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-avdevice"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-avcodec"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-avformat"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-swresample"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-swscale"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-postproc"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-avfilter"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-avresample"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-pthreads"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-w32threads"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-os2threads"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-network"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-dct"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-dwt"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-error-resilience"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-lsp"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-lzo"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-mdct"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-rdft"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-fft"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-faan"
#COMMON_OPTIONS="$COMMON_OPTIONS --disable-pixelutils"

#个别组件选项 这里定义需要定制的组件 encoder decoder hwaccel muxer demuxerparser bsf protocol indev outdev filter
COMMON_OPTIONS="$COMMON_OPTIONS --disable-everything"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-muxer=mp4"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-muxer=h264"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-encoder=libx264"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-encoder=libfdk_aac"


#扩展库支持 这里定义扩展库
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-jni"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-libfdk-aac"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-libmp3lame"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-libx264"
#COMMON_OPTIONS="$COMMON_OPTIONS --enable-libx265"


#硬件加速功能 移动端默认实现了硬编解码


#工具链选项
COMMON_OPTIONS="$COMMON_OPTIONS --target-os=android"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-cross-compile"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-pic"
COMMON_OPTIONS="$COMMON_OPTIONS --pkg-config=pkg-config"

#优化选项 关掉所有优化 如果要优化在各CPU下 EXTRA_OPTIONS 中选择
COMMON_OPTIONS="$COMMON_OPTIONS --disable-asm"

#通用CFLAGS
COMMON_CFLAGS="-Os -fpic -I$SYSROOT/usr/include"
#通用LDFLAGS
COMMON_LDFLAGS="-L$SYSROOT/usr/lib"


#armv8-a
ARCH=arm64
CPU=armv8-a
CC=$TOOLCHAIN/bin/aarch64-linux-android$API64-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API64-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$(pwd)/android/$CPU
EXTRA_OPTIONS=""
EXTRA_OPTIONS="$EXTRA_OPTIONS --enable-neon"
EXTRA_CFLAGS="-march=$CPU"
EXTRA_LDFLAGS=

PKG_CONFIG_PATH=/home/qr/ffmpeg/fdk-aac-2.0.1/android/$CPU/lib/pkgconfig:/home/qr/ffmpeg/x264/android/$CPU/lib/pkgconfig
export PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH
build_android

#armv7-a
ARCH=arm
CPU=armv7-a
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$CPU
EXTRA_OPTIONS=""
EXTRA_OPTIONS="$EXTRA_OPTIONS --enable-neon"
EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
EXTRA_LDFLAGS=

PKG_CONFIG_PATH=/home/qr/ffmpeg/fdk-aac-2.0.1/android/$CPU/lib/pkgconfig:/home/qr/ffmpeg/x264/android/$CPU/lib/pkgconfig
export PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH
build_android

#x86_64
ARCH=x86_64
CPU=x86-64
CC=$TOOLCHAIN/bin/x86_64-linux-android$API64-clang
CXX=$TOOLCHAIN/bin/x86_64-linux-android$API64-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
PREFIX=$(pwd)/android/$CPU
EXTRA_OPTIONS=
EXTRA_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 -mtune=intel"
EXTRA_LDFLAGS=

PKG_CONFIG_PATH=/home/qr/ffmpeg/fdk-aac-2.0.1/android/$CPU/lib/pkgconfig:/home/qr/ffmpeg/x264/android/$CPU/lib/pkgconfig
export PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH
build_android

#x86
ARCH=x86
CPU=x86
CC=$TOOLCHAIN/bin/i686-linux-android$API-clang
CXX=$TOOLCHAIN/bin/i686-linux-android$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
PREFIX=$(pwd)/android/$CPU
EXTRA_OPTIONS=
EXTRA_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
EXTRA_LDFLAGS=

PKG_CONFIG_PATH=/home/qr/ffmpeg/fdk-aac-2.0.1/android/$CPU/lib/pkgconfig:/home/qr/ffmpeg/x264/android/$CPU/lib/pkgconfig
export PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH
build_android
