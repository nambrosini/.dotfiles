. "$HOME/.cargo/env"

export EDITOR=nvim

export PATH=$PATH:/opt/homebrew/Cellar/goto/2.0.0/etc/bash_completion.d:~/go/bin/:/Users/nambrosini/.kafka/bin

export BAT_THEME=catppuccin-mocha

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_T_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
