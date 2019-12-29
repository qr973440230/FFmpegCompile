#!/bin/bash

NDK=/home/qr/ndk/android-ndk-r20-linux-x86_64/android-ndk-r20
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64/
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
API=16
API64=21


function build_android
{
echo "Compiling x264 for $CPU"
./configure \
    	--prefix=$PREFIX \
	--enable-static \
	--enable-pic \
	--enable-strip \
	--disable-cli \
	--disable-asm \
	--host=$HOST \
    	--cross-prefix=$CROSS_PREFIX \
    	--sysroot=$SYSROOT \
	--extra-cflags="$COMMON_CFLAGS $EXTRA_CFLAGS" \
	--extra-ldflags="$COMMON_LDFLAGS $EXTRA_LDFLAGS"

make clean
make -j4
make install
echo "The Compilation of X264 for $CPU is completed"
}

COMMON_CFLAGS="-Os -fpic -I$SYSROOT/usr/include"
COMMON_LDFLAGS="-L$SYSROOT/usr/lib"

#armv8-a
ARCH=arm64
CPU=armv8-a
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-march=$CPU"
EXTRA_LDFLAGS=

HOST=aarch64-linux-android
export AR=$TOOLCHAIN/bin/$HOST-ar
export AS=$TOOLCHAIN/bin/$HOST-as
export CC=$TOOLCHAIN/bin/$HOST$API64-clang
export CXX=$TOOLCHAIN/bin/$HOST$API64-clang++
export LD=$TOOLCHAIN/bin/$HOST-ld
export STRIP=$TOOLCHAIN/bin/$HOST-strip
export NM=$TOOLCHAIN/bin/$HOST-nm
export RANLIB=$TOOLCHAIN/bin/$HOST-ranlib

build_android

#armv7-a
ARCH=arm
CPU=armv7-a
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU "
EXTRA_LDFLAGS=

HOST=arm-linux-androideabi
export AR=$TOOLCHAIN/bin/$HOST-ar
export AS=$TOOLCHAIN/bin/$HOST-as
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
export LD=$TOOLCHAIN/bin/$HOST-ld
export STRIP=$TOOLCHAIN/bin/$HOST-strip
export NM=$TOOLCHAIN/bin/$HOST-nm
export RANLIB=$TOOLCHAIN/bin/$HOST-ranlib

build_android

#x86_64
ARCH=x86_64
CPU=x86-64
CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 -mtune=intel"
EXTRA_LDFLAGS=

HOST=x86_64-linux-android
export AR=$TOOLCHAIN/bin/$HOST-ar
export AS=$TOOLCHAIN/bin/$HOST-as
export CC=$TOOLCHAIN/bin/$HOST$API64-clang
export CXX=$TOOLCHAIN/bin/$HOST$API64-clang++
export LD=$TOOLCHAIN/bin/$HOST-ld
export STRIP=$TOOLCHAIN/bin/$HOST-strip
export NM=$TOOLCHAIN/bin/$HOST-nm
export RANLIB=$TOOLCHAIN/bin/$HOST-ranlib

build_android

#x86
ARCH=x86
CPU=x86
CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
EXTRA_LDFLAGS=

HOST=i686-linux-android
export AR=$TOOLCHAIN/bin/$HOST-ar
export AS=$TOOLCHAIN/bin/$HOST-as
export CC=$TOOLCHAIN/bin/$HOST$API-clang
export CXX=$TOOLCHAIN/bin/$HOST$API-clang++
export LD=$TOOLCHAIN/bin/$HOST-ld
export STRIP=$TOOLCHAIN/bin/$HOST-strip
export NM=$TOOLCHAIN/bin/$HOST-nm
export RANLIB=$TOOLCHAIN/bin/$HOST-ranlib

build_android
