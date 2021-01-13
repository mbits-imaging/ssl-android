#!/bin/sh

ANDROID_NDK=~/Android/Sdk/ndk/21.3.6528147
LIBRESSL_VERSION=3.3.1

API_LEVEL=23
OUT_DIR=$PWD/libressl_binaries

BUILD_TARGETS="armeabi-v7a arm64-v8a x86 x86_64"

if [ ! -d libressl-${LIBRESSL_VERSION} ]
then
    if [ ! -f libressl-${LIBRESSL_VERSION}.tar.gz ]
    then
        wget https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz || exit 128
    fi
    tar xzf libressl-${LIBRESSL_VERSION}.tar.gz || exit 128
fi

cd libressl-${LIBRESSL_VERSION} || exit 128

for build_target in $BUILD_TARGETS
do
    mkdir build-$build_target
    cd build-$build_target

    cmake .. -DCMAKE_INSTALL_PREFIX=$OUT_DIR/$build_target -DLIBRESSL_APPS=OFF -DLIBRESSL_TESTS=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_PLATFORM=$API_LEVEL -DANDROID_ABI=$build_target -G Ninja
    cmake --build .
    cmake --build . --target install
    cd ..

done



