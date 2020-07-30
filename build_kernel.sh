#!/bin/bash

set -e

export CROSS_COMPILE=/home/firemax13/r1q_kernel/sm6150/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64

if [ ! -d out ]; then
	mkdir out
fi

BUILD_CROSS_COMPILE=/home/firemax13/r1q_kernel/sm6150/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=/home/firemax13/r1q_kernel/sm6150/toolchain/clang/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE r1q_eur_open_defconfig
make -j64 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

tools/mkdtimg create out/arch/arm64/boot/dtbo.img --page_size=4096 $(find out -name "*.dtbo")

# More commands here

# error_copy_script
# cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
# This will cause some errors after the last make command is done and the Image is still not produced.
# No need to copy Image into the other location since it is not useful, and it will duplicate and cause such an error when compiling the kernel again without cleaning the out/Image loc after some modifications.
# Disabled till stable script is found.
