EDITOR=nvim

PATH=$PATH:/opt/homebrew/Cellar/goto/2.0.0/etc/bash_completion.d:~/go/bin/:/Users/nambrosini/.kafka/bin

BAT_THEME=tokyonight-storm

# -- Use fd instead of fzf --
FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_T_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"


GOBIN=$HOME/go/bin
