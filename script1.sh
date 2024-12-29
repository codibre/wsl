#!/bin/bash

sudo apt update
sudo apt install btrfs-progs
sudo dd if=/dev/zero of=/btrfs.img bs=1M count=40960
sudo mkfs.btrfs -f /btrfs.img
sudo mkdir /mnt/btrfs
sudo mount -o loop /btrfs.img /mnt/btrfs
sudo btrfs property set /mnt/btrfs compression zstd
