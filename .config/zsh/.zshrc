# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"


# SSH Agent

plugins=(ssh-agent)

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [ ! -f "$SSH_AUTH_SOCK" ]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# Load and initialise completion system
autoload -Uz compinit
compinit

#Cargo apps in PATH
export PATH=$PATH:~/.cargo/bin/

#GPG/pinentry
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

#App theming
export "MICRO_TRUECOLOR=1"
export BAT_THEME="everforest-soft"

#Initialize zoxide
eval "$(zoxide init zsh)"

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

## ALIASES
alias yay="paru"
alias yeet="yay -Rsn"
alias pacman="sudo pacman"
alias hyprconf="micro ~/.config/hypr/hyprland.conf"
alias bindconf="micro ~/.config/hypr/bindings.conf"
alias zshconf="micro ~/.config/zsh/.zshrc"
alias fstab="micro /etc/fstab"
alias m="micro"
alias lg="lazygit"

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cd="zd"
zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}
open() {

  xdg-open "$@" >/dev/null 2>&1 &
}
# Tools
alias d='docker'
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gp='git push -u origin main'

hyfetch
eval "$(starship init zsh)"
