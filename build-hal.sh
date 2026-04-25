#!/bin/bash
rm -rf .repo
source halium.env
cd $ANDROID_ROOT
export LINK_FULL TARGET
sed -i '/curl --location/c\python3 -c '\''import urllib.request,ssl,os;ctx=ssl.create_default_context();ctx.check_hostname=False;ctx.verify_mode=ssl.CERT_NONE;urllib.request.urlretrieve(os.environ["LINK_FULL"], os.environ["TARGET"])'\''' halium/halium-boot/get-initrd.sh

source build/envsetup.sh
#export USE_CCACHE=1
breakfast $DEVICE
make -j$(nproc) halium-boot
make -j$(nproc) recoveryimage
#make -j$(nproc) systemimage 

echo "md5sum halium-boot.img and system.img"
md5sum $ANDROID_ROOT/out/target/product/lmi/halium-boot.img
md5sum $ANDROID_ROOT/out/target/product/lmi/recovery.img
#md5sum $ANDROID_ROOT/out/target/product/lmi/system.img
