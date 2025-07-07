fish_add_path "$HOME/.cargo/env"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.kafka/bin"
fish_add_path "$HOME/.zig/zig"

set -x EDITOR 'nvim'

set -x BAT_THEME 'tokyonight-storm'

# -- Use fd instead of fzf --
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_ALT_T_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

set -x SOPS_PGP_FP $(gpg --fingerprint | grep "2FEC 5757 8FFB 5277 1E40  8D36 950A 37FD 7688 BD8B" | cut -d'=' -f 2 | sed 's/ //g')

set -x GOBIN $HOME/go/bin
