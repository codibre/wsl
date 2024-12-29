add

/btrfs.img /home/user btrfs loop,compress=zstd 0 0
to
/etc/fstab


add

[automount]
mountFsTab=true

to

/etc/wsl.conf
