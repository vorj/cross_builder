#!/bin/bash -ex

IMG=ubuntu-18.04.5-preinstalled-server-arm64+raspi3.tar.xz
HERE=$(pwd)

if [ $# -ne 1 ]; then
  echo "usage: $0 username"
  exit 1
fi

set -e

ls -l ${IMG}

WORKDIR=.chroot_dir/$(basename ${IMG} .tar.xz)

pushd ${WORKDIR}
QEMU_PATH=$(update-binfmts --display | grep qemu-arm-static | awk '{print $3}')
ls -l ${QEMU_PATH}
sudo mount -t sysfs sysfs ./sys
sudo mount -t proc proc ./proc
sudo mount -t devtmpfs udev ./dev
sudo mount -t devpts devpts ./dev/pts
sudo mount --bind /run ./run
sudo mount -o ro,bind /etc/group ./etc/group
sudo mount -o ro,bind /etc/passwd ./etc/passwd
sudo mkdir -p ./home/$1
sudo mount --bind ${HERE}/project ./home/$1

set +e

sudo chroot --userspec $USER . /home/$1/build.bash

set -e

sudo umount ./home/$1
sudo umount ./etc/passwd
sudo umount ./etc/group
sudo umount ./run
sudo umount ./dev/pts
sudo umount ./dev
sudo umount ./proc
sudo umount ./sys
popd
