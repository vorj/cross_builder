#!/bin/bash -ex

IMG=ubuntu-18.04.5-preinstalled-server-arm64+raspi3.img
URL=http://cdimage.ubuntu.com/releases/bionic/release/${IMG}.xz

wget ${URL}
xz -dv ${IMG}.xz
sudo losetup -frP ${IMG}
LOOPDEV=$(losetup -l | grep $(realpath ${IMG}) | awk '{print $1}')
sudo fdisk -l ${LOOPDEV}
mkdir -p ./loop_mnt
sudo mount -o ro ${LOOPDEV}p2 ./loop_mnt
sudo tar cvJf ./${IMG%.*}.tar.xz -C ./loop_mnt .
sudo umount ./loop_mnt
rmdir ./loop_mnt
sudo losetup -d ${LOOPDEV}
rm ${IMG}

HERE=$(pwd)
WORKDIR=.chroot_dir/${IMG%.*}
mkdir -p ${WORKDIR}
pushd ${WORKDIR}
sudo tar xpJf ${HERE}/${IMG%.*}.tar.xz
popd
