# cross builder

## prerequisites

- `qemu-user-static`

## usage (in general)

1. create the scripts for the environments
1. run the scripts in order

### ubuntu-18.04.05.bionic-raspi

bionic for raspi

1. create `project` directory
    - `project/create_env.bash` : script for environment settings. this script will be run as root
    - `project/build.bash` : script for build software. this script will be run as non-root user
1. run the `18.04.05.bionic-raspi.sh` in order
