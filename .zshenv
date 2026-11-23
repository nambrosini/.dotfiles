# ─── Homebrew ─────────────────────────────────────────────────────────────────
# macOS (Apple Silicon / Intel) or Linuxbrew (Ubuntu/Arch)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [[ -x "$_brew" ]] && eval "$("$_brew" shellenv)" && break
done
unset _brew

# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ─── Go ───────────────────────────────────────────────────────────────────────
export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/go"

# ─── Java ─────────────────────────────────────────────────────────────────────
if [[ -x /usr/libexec/java_home ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"        # macOS
elif command -v java &>/dev/null; then
  export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"  # Linux (Ubuntu/Arch)
fi
[[ -n "$JAVA_HOME" ]] && export INSTALL4J_JAVA_HOME="$JAVA_HOME"

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
  --color=bg+:#3d484d,bg:#2d353b,spinner:#d699b6,hl:#e67e80
  --color=fg:#d3c6aa,header:#e67e80,info:#7fbbb3,pointer:#d699b6
  --color=marker:#a7c080,fg+:#d3c6aa,prompt:#7fbbb3,hl+:#e67e80
  --color=selected-bg:#543a48
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
  "$JAVA_HOME/bin"
  "$HOME/.config/emacs/bin"
  $path
)
export PATH

# ─── Rust ─────────────────────────────────────────────────────────────────────
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ─── ESP32 ────────────────────────────────────────────────────────────────────
[[ -f "$HOME/export-esp.sh" ]] && . "$HOME/export-esp.sh"

[[ -f "$HOME/.bitwarden-ssh-agent.sock" ]] && export SSH_AUTH_SOCK=/Users/nambrosini/.bitwarden-ssh-agent.sock
