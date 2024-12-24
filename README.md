# wsl
Repo with useful wsl resources

## base wsl image

Here you can find a bae wsl image with:
* github cli
* nvm and node 22
* zsh
* oh-my-zsh with autosuggestions and syntax-highlighting
* docker
* /home/user using btrfs with zstd compression, for better disk usage


Also, every image of docker is put inside /home/user, to use the said compression, saving disk space

To import this image, just download, uncompress it, and run the following:
```bash
wsl --import myubuntu --version 2 $env:USERPROFILE\my-ubuntu .\ext4.vhdx --vhd
```

You can change the distribution to whatever you want, like Ubuntu, and that's it! It's ready to use.
