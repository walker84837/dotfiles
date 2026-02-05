# dotfiles

> A collection of configuration files for a personalized development environment

This repository contains the configurations of the applications I use on my computers to create a seamless development environment.

## Installing / Getting started

To get started with this project, you'll need to clone the repository and install the required dependencies.

```shell
$ cd ~
$ git clone --recurse-submodules https://github.com/walker84837/dotfiles.git
```

This command clones the repository and initializes the submodules. Once the cloning has finished:

``` console
$ cd dotfiles
$ stow --adopt .
```

## Dependencies

Some scripts in [`.local/share/scripts`](https://github.com/walker84837/dotfiles/tree/master/.local/share/scripts) are written in JavaScript and require [Node.js](https://nodejs.org) to be installed.

### Initial Configuration

To use this project, you'll need to have the following dependencies installed:

#### Basic dependencies

* [GNU stow](https://www.gnu.org/software/stow) to manage configuration files
* [Zsh](https://www.zsh.org)
  * Change your user's shell with: `chsh -s /bin/zsh`
  * Log out and log back in to make the change take effect
* [eza](https://github.com/eza-community/eza) for `ls` and better appearance
* [zoxide](https://github.com/ajeetdsouza/zoxide) for `cd` and efficient navigation
* [fzf](https://github.com/junegunn/fzf) for fuzzy search on shell completion

#### Full dependencies

* [Git](https://git-scm.com)
* [Btop](https://github.com/aristocratos/btop)
* [Neovim](https://neovim.io)
* [Zellij](https://zellij.dev) 
* Any [Nerd Font](https://www.nerdfonts.com), but I recommend Iosevka or JetBrains Mono.

## Features

This project provides a collection of configuration files for a personalized development environment, including:

* **Tmux settings**: tpm & catppuccin
* **Btop settings**: theme
* **Zsh settings**: p10k & zinit
* **Neovim configuration**: lazy.nvim + codeium

## Licensing

The code in this project is licensed under [MIT License](LICENSE.md).
