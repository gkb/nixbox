#!/bin/sh -e

packer_http=$(cat .packer_http)

# Partition disk
# TODO: Change this to something more appropriate once I figure out the right commands to use.
# TODO: Check out the disk size and make adjustments. I currently assume a disk size that's
# multiples of 8GB.
# TODO: Set the swap space size to be 2GB more than the memory size.
cat <<PARTED | parted /dev/nvme0n1
mklabel gpt
mkpart primary 512MB -8GB
mkpart primary linux-swap -8GB 100%
mkpart ESP fat32 1MB 512MB
set 3 esp on
PARTED

# Create filesystem
mkfs.ext4 -j -L nixos /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

# Mount filesystem
mount LABEL=nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Set up the swap space
swapon /dev/nvme0n1p2

# Setup system
nixos-generate-config --root /mnt

curl -sf "$packer_http/vagrant.nix" > /mnt/etc/nixos/vagrant.nix
curl -sf "$packer_http/vagrant-hostname.nix" > /mnt/etc/nixos/vagrant-hostname.nix
curl -sf "$packer_http/vagrant-network.nix" > /mnt/etc/nixos/vagrant-network.nix
curl -sf "$packer_http/builders/$PACKER_BUILDER_TYPE.nix" > /mnt/etc/nixos/hardware-builder.nix
curl -sf "$packer_http/configuration.nix" > /mnt/etc/nixos/configuration.nix
curl -sf "$packer_http/custom-configuration.nix" > /mnt/etc/nixos/custom-configuration.nix

### Install ###
nixos-install

### Cleanup ###
curl "$packer_http/postinstall.sh" | nixos-enter
