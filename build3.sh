#!/bin/bash


# paths
TC="/media/macka/Main/toolchain"

PATH=${TC}/clang-r416183b1/bin:${TC}/aarch64/bin:${TC}/arm/bin:$PATH

#export CLANG_TRIPLE="/home/macka/toolchains/gcc/bin/aarch64-linux-gnu-"
export LLVM=1
#export PATH="/media/macka/Main/toolchain/clang/bin:$PATH"
export CC=clang
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export USE_CCACHE=1

make O=out ARCH=arm64 vendor/lmi_user_defconfig

START=$(date +"%s")


#make -j$(nproc --all) O=out CONFIG_BUILD_ARM64_KERNEL_COMPRESSION_GZIP=y CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y CONFIG_LTO_CLANG=y

make ARCH=arm64 \
        O=out \
        CC=clang \
        AR=llvm-ar \
        LD=ld.lld \
        NM=llvm-nm \
        OBJCOPY=llvm-objcopy \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip \
        -j$(nproc --all)
               
END=$(date +"%s")
DIFF=$((END - START))
echo -e '\033[01;32m' "Kernel compiled successfully in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds" || exit
