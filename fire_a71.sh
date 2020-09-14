#!/bin/bash

set -e

# Put the Kernel Path in here and fire it up
# No need to change the whole and entire file to set-up kernel path
KERNEL_PATH=/home/firemax13/r1qkernel

# Export GCC and ARCH
export CROSS_COMPILE=$KERNEL_PATH/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64

# Output hacking & tricking
if [ ! -d out ]; then
	mkdir out
fi

# Types, paths, and more etc.
BUILD_CROSS_COMPILE=$KERNEL_PATH/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$KERNEL_PATH/toolchain/clang/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make -C $KERNEL_PATH O=$KERNEL_PATH/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE a71_eur_open_defconfig
make -j4 -C $KERNEL_PATH O=$KERNEL_PATH/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

tools/mkdtimg create out/arch/arm64/boot/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
