export XDG_CONFIG_HOME=$HOME/.config

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit file
source "$ZINIT_HOME/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit -C

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.yaml)"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History 
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion;*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

# Completions
source <(kubectl completion zsh)
source <(helm completion zsh)
source <(oc completion zsh)
source <(arduino-cli completion zsh)

# Aliases
if [ -f ~/.zsh/aliases.zsh ]; then
  source ~/.zsh/aliases.zsh
fi

# Shell integrations
# -- FZF --
eval "$(fzf --zsh)"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# -- Zoxide --
eval "$(zoxide init --cmd cd zsh)"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$USER/.local/bin"

eval $(thefuck --alias)

export SOPS_PGP_FP=$(gpg --fingerprint | grep "2FEC 5757 8FFB 5277 1E40  8D36 950A 37FD 7688 BD8B" | cut -d'=' -f 2 | sed 's/ //g')

# Created by `pipx` on 2024-08-13 07:11:12
export PATH="$PATH:/Users/nambrosini/.local/bin"
export PATH="$PATH:$HOME/.zig"


# Herd injected NVM configuration
export NVM_DIR="/Users/nambrosini/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/nambrosini/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP binary.
export PATH="/Users/nambrosini/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/nambrosini/Library/Application Support/Herd/config/php/84/"

export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH
export INSTALL4J_JAVA_HOME=$(/usr/libexec/java_home)

# source $HOME/.kafka_ticket.sh
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/nambrosini/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
