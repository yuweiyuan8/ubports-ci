#!/bin/bash
rm -rf .repo
source halium.env
cd $ANDROID_ROOT
sed -i '/curl --location/c\ python3 - <<EOF\n\ import urllib.request, ssl, sys\n\ url = "'"$LINK_FULL"'"\n\ out = "'"$TARGET"'"\n\ ctx = ssl.create_default_context()\n\ ctx.check_hostname = False\n\ ctx.verify_mode = ssl.CERT_NONE\n\ with urllib.request.urlopen(url, context=ctx) as r:\n\     data = r.read()\n\ open(out, "wb").write(data)\n\ EOF' halium/halium-boot/get-initrd.sh

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
