#!/bin/bash -ex

IMG=ubuntu-18.04.5-preinstalled-server-arm64+raspi3.tar.xz
HERE=$(pwd)

ls -l ${IMG}

WORKDIR=.chroot_dir/$(basename ${IMG} .tar.xz)

pushd ${WORKDIR}
QEMU_PATH=$(update-binfmts --display | grep qemu-arm-static | awk '{print $3}')
ls -l ${QEMU_PATH}
sudo cp ${QEMU_PATH} .${QEMU_PATH}
sudo mount -t sysfs sysfs ./sys
sudo mount -t proc proc ./proc
sudo mount -t devtmpfs udev ./dev
sudo mount -t devpts devpts ./dev/pts
sudo mount -o ro,bind /etc/group ./etc/group
sudo mount -o ro,bind /etc/passwd ./etc/passwd
sudo mount --bind /run ./run
sudo mkdir -p ./root
sudo mount --bind ${HERE}/project ./root

set +e

sudo chroot . /root/create_env.bash

set -e

sudo umount ./root
sudo umount ./run
sudo umount ./etc/passwd
sudo umount ./etc/group
sudo umount ./dev/pts
sudo umount ./dev
sudo umount ./proc
sudo umount ./sys
popd
