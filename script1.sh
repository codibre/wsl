#!/bin/bash

sudo apt update
sudo apt install btrfs-progs -y
sudo dd if=/dev/zero of=/btrfs.img bs=1M count=40960
sudo mkfs.btrfs -f /btrfs.img
sudo mkdir /mnt/btrfs
sudo mount -o loop /btrfs.img /mnt/btrfs
sudo btrfs property set /mnt/btrfs compression zstd

# Add entry to /etc/fstab
echo "/btrfs.img /home/user btrfs loop,compress=zstd 0 0" | sudo tee -a /etc/fstab

# Add entry to /etc/wsl.conf
sudo bash -c 'cat <<EOF >> /etc/wsl.conf
[automount]
mountFsTab=true
EOF'

cd /
sudo umount /home/user
sudo mount -a
