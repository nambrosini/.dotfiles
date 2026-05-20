# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ─── Go ───────────────────────────────────────────────────────────────────────
export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/go"

# ─── FZF ──────────────────────────────────────────────────────────────────────
# Use fd as the default source (respects .gitignore, shows hidden files)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# FZF appearance: use bat for file preview, show in a nice layout
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --preview-window='right:55%:wrap'
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-u:preview-half-page-up'
  --bind='ctrl-d:preview-half-page-down'
  --color=bg+:#292e42,bg:#24283b,spinner:#bb9af7,hl:#f7768e
  --color=fg:#c0caf5,header:#f7768e,info:#7aa2f7,pointer:#bb9af7
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#f7768e
  --color=selected-bg:#364a82
"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :200 {}'"
export FZF_ALT_C_OPTS="--preview 'ls --color=always {}'"

# ─── SOPS ─────────────────────────────────────────────────────────────────────
# Computed lazily at shell start; gpg call is unavoidable here
export SOPS_PGP_FP=$(gpg --fingerprint 2>/dev/null \
  | grep "2FEC 5757 8FFB 5277 1E40  8D36 950A 37FD 7688 BD8B" \
  | cut -d'=' -f2 \
  | tr -d ' ')

# ─── PATH ─────────────────────────────────────────────────────────────────────
# Build PATH once, avoiding duplicates via typeset -U
typeset -U path
path=(
  "$GOBIN"
  /go/bin
  "$HOME/.kafka/bin"
  "$HOME/.local/bin"
  $path
)
export PATH
