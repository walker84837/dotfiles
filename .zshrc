# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Set up environment variables early
export PATH="/home/$USER/.local/bin:$PATH"
export GOPATH=~/.cache/go

# Source Commands
source "${ZINIT_HOME}/zinit.zsh"
source /home/$USER/.config/broot/launcher/bash/br

# Options and History Settings
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

# Zsh Options
bindkey -v
bindkey '^p' history-search-forward
bindkey '^n' history-search-backward

# Aliases
alias ls="exa"
alias clock="tty-clock -SscC 4"
alias cat="bat -Pp"
alias tree="exa --tree"
alias bc="bc -ql"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"

# Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Oh My Zsh snippets
zinit snippet OMZP::cp 
zinit snippet OMZP::git 
zinit snippet OMZP::zoxide
zinit snippet OMZP::kitty
zinit snippet OMZP::command-not-found

# Evaluations
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# Functions
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
	orig_path=$1
	path_stripped="${orig_path%.*}"

	ffmpeg -y -i $1 -c:v h264_nvenc -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$path_stripped.mp4" || return
}

discord_upgrade() {
	DISCORD_INSTALL="/opt/discord"

    # Step 1: Remove Discord install to remove conflicting files
    printf "Removing Discord install at $DISCORD_INSTALL...\n"
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

# Zsh Style Configurations
zstyle ':omz:update' frequency 30
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Zinit stuff
autoload -Uz compinit && compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
