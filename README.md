# wsl
Repo with useful wsl resources

## base wsl image

Here you can find a base wsl script with:
* github cli
* nvm and node 22
* zsh
* oh-my-zsh with autosuggestions and syntax-highlighting
* docker
* /home/user using btrfs with zstd compression, for better disk usage


Also, every image of docker is put inside $HOME, to use the said compression, saving disk space

To execute it, run the following steps:

* At powershell, install wsl if it's not installed yet
```bash
wsl --install
```
* At powershell, install your wsl distribution. If you have one already, I advise you to install a new one
```bash
wsl --install Ubuntu
```
* Now, inside wsl, run the following script
```bash
curl -fsSL https://raw.githubusercontent.com/codibre/wsl/refs/heads/main/install-resources.sh | bash
```

It's important now ti close the terminal and open wsl again, as some docker permissions will only be assumed after restart, and that's it! You're ready to go!
