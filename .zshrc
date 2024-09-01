# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/walker84837/.local/bin:$PATH"
#export FREEPLANE_USE_UNSUPPORTED_JAVA_VERSION=1

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

ZSH_THEME="gentoo"
# source "$HOME/.oh-my-zsh/themes/headline.zsh-theme"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(cp git rust zoxide fzf-tab kitty)

source $ZSH/oh-my-zsh.sh

# User configuration

alias ls="exa"
alias ll="exa -lah"
alias cat="bat -Pp"
alias tree="exa --tree"
alias bc="bc -ql"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"

export GOPATH=~/.cache/go

clr_scrollback() {
	printf '\033[3J'
	clear
}

rename_files() {
    counter=1
    for file in *; do
        if [[ -f "$file" ]]; then
            extension="${file##*.}"
            new_name=$(printf "%03d" "$counter")
            mv "$file" "$new_name"
            ((counter++))
        fi
    done
}

add_identity() {
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/winlogon
}

gif2mp4() {
	orig_path=$1;
	path_stripped="${orig_path%.*}"
	
	ffmpeg -y -i $1 -c:v h264_nvenc -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$path_stripped.mp4" || return
}

c_project() {
	mkdir $1 && cd $1
	mkdir src docs
	touch README.md LICENSE.md CHANGELOG.md CODE_OF_CONDUCT.md Makefile src/main.c docs/placeholder.md
}

discord_upgrade() {
	DISCORD_INSTALL="/opt/discord"

	# Step 1: Remove Discord install to remove conflicting files
	printf "Removing Discord install at "$DISCORD_INSTALL"...\n"
	sudo rm -rf "$DISCORD_INSTALL" || return

	# Step 2: Download the Vencord installer by getting the executable file from the POSIX sh script.
	printf "Extracting installer path from POSIX sh script...\n"
	INSTALLER_URL=$(curl -Ss https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh | grep -o 'http[s]*://[^"]*' | awk 'NR==1' | sed 's/\\$//' | sed 's/\s*$//') || return

	# Step 2-1: Get the file path from the download link in the POSIX sh script.
	printf "Getting file name from URL...\n"
	INSTALLER_PATH=$(mktemp)

	# Step 3: Download the Vencord installer
	wget "$INSTALLER_URL" -O "$INSTALLER_PATH"
	chmod 755 "$INSTALLER_PATH"

	# Step 4: Reinstall Discord and download basic modules
	sudo pacman --noconfirm -S discord
	timeout 5m bash -c 'discord > /dev/null'

	# Step 5: Install Vencord on the Discord installation
	printf "Installing Vencord to '$DISCORD_INSTALL'...\n"
	sudo $INSTALLER_PATH -install -location "$DISCORD_INSTALL"
	printf "Installing OpenAsar to '$DISCORD_INSTALL'...\n"
	sudo $INSTALLER_PATH -install-openasar -location "$DISCORD_INSTALL"

	# Step 6: Clean up temporary files
	printf "Cleaning up temporary files...\n"
	printf "Removing $INSTALLER_PATH...\n"
	rm -rf "$INSTALLER_PATH" || return
}

change_wallpaper() {
	swww img "$1" --transition-fps 60 --transition-type wipe --transition-duration 2
	wallust run "$1" -s
}

bindkey -v
bindkey '^p' history-search-forward
bindkey '^n' history-search-backward

source /home/walker84837/.config/broot/launcher/bash/br
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

autoload -U compinit && compinit
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
