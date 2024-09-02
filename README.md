# dotfiles
> A collection of configuration files for a personalized development environment

This repository contains the configurations of the applications I use on my computers to create a seamless development environment.

## Installing / Getting started

To get started with this project, you'll need to clone the repository and install the required dependencies.

```shell
$ cd ~
$ git clone --recurse-submodules http://winlogon.ddns.net/winlogon/dotfiles.git
```

This command clones the repository and initializes the submodules. Once the cloning has finished:

``` console
$ cd dotfiles
$ stow --adopt .
```

### Initial Configuration

To use this project, you'll need to have the following dependencies installed:

* [GNU stow](https://www.gnu.org/software/stow)
* [Git](https://git-scm.com)
* [Zsh](https://www.zsh.org)
* [Btop](https://github.com/aristocratos/btop)

## Features

This project provides a collection of configuration files for a personalized development environment, including:

* Editor configurations (coming soon)
* Tmux settings (tpm & catppuccin)
* Btop settings
* Zsh settings (p10k & zinit)

## Licensing

The code in this project is licensed under [MIT License](LICENSE.md).
