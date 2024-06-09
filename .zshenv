. "$HOME/.cargo/env"

EDITOR=nvim

PATH=$PATH:/opt/homebrew/Cellar/goto/2.0.0/etc/bash_completion.d:~/go/bin/:/Users/nambrosini/.kafka/bin

BAT_THEME=tokyonight-storm

# -- Use fd instead of fzf --
FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_T_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

SOPS_PGP_FP=$(gpg --fingerprint | grep "2FEC 5757 8FFB 5277 1E40  8D36 950A 37FD 7688 BD8B" | cut -d'=' -f 2 | sed 's/ //g')

GOBIN=$HOME/go/bin
