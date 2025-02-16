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
export PATH="/home/$USER/.local/bin:/home/$USER/.local/share/coursier/bin:$PATH"
export GOPATH=~/.cache/go

# Source Commands
source "${ZINIT_HOME}/zinit.zsh"

# Options and History Settings
HISTSIZE=5000
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
alias ls="exa --icons --grid"
alias clock="tty-clock -SscC 4"
alias cat="bat -Pp"
alias tree="exa --tree"
alias bc="bc -ql"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias xcd='cd "$(xplr)"'

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
	ssh-add ~/.ssh/id_github
	ssh-add ~/.ssh/id_codecove
}

gif2mp4() {
	if [[ "$1" == "--help" ]]; then
		echo "Usage: gif2mp4 <path_to_gif> <resolution :: optional [720p]>"
		echo "Example (720p): gif2mp4 test.gif 720"
		return
	fi
	local resolution
	if [[ -z "$2" ]]; then
		resolution=720
	else
		resolution=$2
	fi
	orig_path=$1
	path_stripped="${orig_path%.*}"

	ffmpeg -y -i "$orig_path" -c:v libvpx-vp9 -b:v 0 -crf 18 -vf "scale=-1:$2,fps=30" -pix_fmt yuv420p "$path_stripped.mp4" || return
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
