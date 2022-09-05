#!/bin/sh
#echo "Unzipping tarball"
#tar -x -f qemu-*-.tar.xz
cd qemu-*
echo "Runnning Configuration script"
./configure --target-list=x86_64-softmmu --enable-vnc --enable-vhost-kernel --enable-vhost-net --enable-kvm --enable-system --disable-gtk
echo "Building"
cd build 
make -j4
echo "Done. Building package."
bash ../gen-rpm.sh
