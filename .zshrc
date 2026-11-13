# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  .zshrc                                                                      ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ─── Zinit ────────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Load plugins with turbo mode (deferred loading = faster startup)
zinit wait lucid light-mode for \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab \
  atinit"zicompinit; zicdreplay" \
    zsh-users/zsh-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# OMZ snippets — load with turbo mode too
# OMZP::docker is NOT in this list: it is loaded conditionally near the end of
# this file, only when a real Docker CLI is installed.
zinit wait lucid for \
  OMZP::aws \
  OMZP::command-not-found \
  OMZP::git \
  OMZP::helm \
  OMZP::kubectl \
  OMZP::kubectx \
  OMZP::oc \
  OMZP::sudo

# ─── Prompt ───────────────────────────────────────────────────────────────────
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/myconfig.yaml)"

# ─── History ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=$HISTSIZE

setopt appendhistory          # Append instead of overwrite
setopt sharehistory           # Share across sessions in real-time
setopt hist_ignore_space      # Don't save commands prefixed with space
setopt hist_ignore_all_dups   # Remove older duplicate entries
setopt hist_save_no_dups      # Don't save duplicates
setopt hist_find_no_dups      # Skip duplicates when searching

# ─── Key Bindings ─────────────────────────────────────────────────────────────
bindkey -e                          # Emacs baseline (Ctrl+A/E/W/etc.)
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space            # Expand !! inline on space

# Edit current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Quick git commit scaffolding: Ctrl+X g c
bindkey -s '^Xgc' 'git commit -m ""\C-b'

# ─── Completion ───────────────────────────────────────────────────────────────
autoload -Uz zmv                    # batch rename utility

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colored completions
zstyle ':completion:*' menu-no                             # use fzf-tab instead of menu

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*'           fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*'   fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-header -w -w'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
  'git log --oneline --graph --color $word'

# ─── Aliases ──────────────────────────────────────────────────────────────────

# ── Filesystem ────────────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -lAhF'
alias lt='ls -lAhFt'                # sort by time
alias lS='ls -lAhFS'                # sort by size
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'             # make intermediate dirs, verbose
alias cp='cp -iv'                   # confirm overwrites, verbose
alias mv='mv -iv'

# ── Better defaults ───────────────────────────────────────────────────────────
alias grep='rg'
# Custom themes in .config/bat/themes/ need a one-time cache build to be found
[[ -d "$HOME/.config/bat/themes" && ! -f "$HOME/.cache/bat/themes.bin" ]] && bat cache --build &>/dev/null
alias cat='bat'
alias vim='nvim'
alias diff='delta'                  # use delta for diffs
alias du='du -sh'
alias df='df -h'
alias top='htop 2>/dev/null || top' # prefer htop if installed

# ── Git ───────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gp='git push'
alias gpf='git push --force-with-lease'  # safe force push
alias gpl='git pull --rebase'
alias gl='git log --oneline --graph --decorate -20'
alias gll='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gstp='git stash pop'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbr='git branch -vv'
alias gpr='gh pr create --web'       # open PR on GitHub in browser
alias gwt='git worktree'

# ── Kubernetes ────────────────────────────────────────────────────────────────
alias k='kubectl'
alias kctl='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias ke='kubectl exec -it'
alias kdel='kubectl delete'
alias kctx='kubectx'
alias kns='kubens'
alias kgp='kubectl get pods'
alias kgpw='kubectl get pods -w'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kge='kubectl get events --sort-by=.lastTimestamp'
alias kgi='kubectl get ingress'

# ── Docker ────────────────────────────────────────────────────────────────────
# Whether `docker` maps to a real Docker CLI or to podman is decided at the
# bottom of this file (compdef only exists after compinit runs) — see the
# "Docker / podman" section there.
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dprune='docker system prune -af'

# ── Misc / tools ──────────────────────────────────────────────────────────────
alias redpanda='/opt/redpanda/Redpanda-Console-SC.sh'
alias reload='source ~/.zshrc'      # reload config
alias zrc='$EDITOR ~/.zshrc'        # quick edit
alias zenv='$EDITOR ~/.zshenv'
alias path='echo $PATH | tr ":" "\n" | nl'  # readable PATH

# ── Suffix aliases ────────────────────────────────────────────────────────────
alias -s md='bat'
alias -s go="$EDITOR"
alias -s rs="$EDITOR"
alias -s zig="$EDITOR"
alias -s java="$EDITOR"
alias -s yaml='bat -l yaml'
alias -s yml='bat -l yaml'
alias -s json='jless'
alias -s toml='bat -l toml'

# ── Global aliases (inline pipes) ─────────────────────────────────────────────
alias -g JQ='| jq'
alias -g C='| pbcopy'
alias -g P='pbpaste'
alias -g L='| less'
alias -g G='| rg'
alias -g NUL='>/dev/null 2>&1'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g U='| sort -u'
alias -g WC='| wc -l'

# ─── Functions ────────────────────────────────────────────────────────────────

# cd and immediately list contents
cl() { cd "$@" && ls --color=auto; }

# Create a directory and enter it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive format
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"  ;;
      *.tar.gz)   tar xzf "$1"  ;;
      *.tar.xz)   tar xJf "$1"  ;;
      *.tar.zst)  tar --zstd -xf "$1" ;;
      *.bz2)      bunzip2 "$1"  ;;
      *.gz)       gunzip "$1"   ;;
      *.tar)      tar xf "$1"   ;;
      *.tbz2)     tar xjf "$1"  ;;
      *.tgz)      tar xzf "$1"  ;;
      *.zip)      unzip "$1"    ;;
      *.7z)       7z x "$1"     ;;
      *.xz)       unxz "$1"     ;;
      *.zst)      unzstd "$1"   ;;
      *)          echo "'$1' cannot be extracted by extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# fzf + bat file preview and open in editor
fe() {
  local file
  file=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n $file ]] && $EDITOR "$file"
}

# fzf + zoxide interactive jump
fj() {
  local dir
  dir=$(zoxide query --list | fzf --preview 'ls --color=always {}')
  [[ -n $dir ]] && cd "$dir"
}

# Fuzzy kill process
fkill() {
  local pid
  pid=$(ps aux | fzf --header='Select process to kill' | awk '{print $2}')
  [[ -n $pid ]] && kill -${1:-9} "$pid"
}

# kubectl: fuzzy switch context
kctxf() {
  local ctx
  ctx=$(kubectl config get-contexts -o name | fzf --prompt='kubectl context> ')
  [[ -n $ctx ]] && kubectl config use-context "$ctx"
}

# kubectl: fuzzy switch namespace
knsf() {
  local ns
  ns=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --prompt='namespace> ')
  [[ -n $ns ]] && kubectl config set-context --current --namespace="$ns"
}

# kubectl: interactive logs with fzf pod picker
klogs() {
  local ns="${1:---all-namespaces}"
  local pod
  pod=$(kubectl get pods ${ns:+-n $ns} --no-headers | fzf | awk '{print $1}')
  [[ -n $pod ]] && kubectl logs -f ${ns:+-n $ns} "$pod"
}

# git: fuzzy checkout branch
gcof() {
  local branch
  branch=$(git branch -a --color=always | rg -v '/HEAD\s' \
    | fzf --ansi --preview 'git log --oneline --graph --color {1}' \
    | sed 's|remotes/[^/]*/||' | tr -d '* ')
  [[ -n $branch ]] && git checkout "$branch"
}

# git: fuzzy add files
gaf() {
  local files
  files=$(git -c color.status=always status --short \
    | fzf --multi --ansi --preview 'git diff --color {2}' \
    | awk '{print $2}')
  [[ -n $files ]] && git add ${(f)files}
}

# Print all colors for terminal debugging
colors() {
  for i in {0..255}; do
    printf "\e[38;5;${i}m %3d " $i
    (( (i+1) % 16 == 0 )) && echo
  done
  echo
}

# ─── Shell Integrations ───────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# ─── Node (fnm) ───────────────────────────────────────────────────────────────
# fnm replaces nvm — much faster (Rust-based)
# Install: brew install fnm
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ─── Rust (rustup/cargo completions) ──────────────────────────────────────────
# cargo's own _cargo completion (loaded via fpath below, not eval'd) ends in
# a bare self-call that only works from a real completion context, so it
# must be autoloaded lazily rather than sourced eagerly here.
if command -v rustc &>/dev/null; then
  fpath+=("$(rustc --print sysroot)/share/zsh/site-functions")
fi
# zinit defers compinit until idle (turbo mode); force it now so compdef
# and the fpath addition above are picked up before rustup's own eval runs.
(( $+functions[compdef] )) || { autoload -Uz compinit && compinit -C }
if command -v rustup &>/dev/null; then
  eval "$(rustup completions zsh)"
fi

# cargo's bundled zsh completion never wires up `--bin` names for `cargo run`;
# patch _cargo to complete them via `cargo metadata`. Deferred until the
# first real Tab press: forcing _cargo to load+run outside an actual
# completion context trips its internal `_arguments` guard.
if command -v cargo &>/dev/null && command -v jq &>/dev/null; then
  _cargo_bin_names() {
    local -a names
    names=(${(f)"$(cargo metadata --no-deps --format-version=1 2>/dev/null \
      | jq -r '.packages[].targets[] | select(.kind[] == "bin") | .name')"})
    _describe 'binary' names
  }
  _cargo_patch_bin_completion() {
    compdef _cargo cargo
    _cargo "$@"
    functions[_cargo]="${functions[_cargo]//--bin=\[name of the bin target\]:name/--bin=[name of the bin target]:name:_cargo_bin_names}"
  }
  compdef _cargo_patch_bin_completion cargo
fi

# ─── Docker / podman ──────────────────────────────────────────────────────────
# Use the real Docker CLI when installed; otherwise route `docker` to podman.
# `command -v docker` alone can't tell the two apart: without real Docker,
# `docker` is often a podman wrapper script whose --version prints
# "podman version …" — the version output is the discriminator.
# This has to run after compinit is forced above (compdef doesn't exist
# before that).
if [[ "$(command docker --version 2>/dev/null)" == "Docker version"* ]]; then
  # Real Docker CLI — the OMZ docker plugin provides aliases + completion.
  # Loaded eagerly here (turbo registration this late in .zshrc is not
  # reliable); the plugin sources a local file and shells out only in the
  # background.
  zinit snippet OMZP::docker
elif (( $+commands[podman] )); then
  # No real Docker — route docker to podman and reuse podman's completion
  # (Homebrew puts _podman on fpath). OMZP::docker must NOT be loaded here:
  # its version check can't parse the podman wrapper's output, falls back to
  # a cp of a completion file that doesn't exist in the zinit snippet, and
  # prints an error on every shell startup.
  alias docker='podman'
  compdef _podman docker
fi

# ─── Clipboard ────────────────────────────────────────────────────────────────
# pbcopy/pbpaste are macOS-only; shim them on Linux for the C/P global aliases
if [[ "$OSTYPE" != darwin* ]] && ! command -v pbcopy &>/dev/null; then
  if command -v xclip &>/dev/null; then
    pbcopy() { xclip -selection clipboard }
    pbpaste() { xclip -selection clipboard -o }
  elif command -v xsel &>/dev/null; then
    pbcopy() { xsel --clipboard --input }
    pbpaste() { xsel --clipboard --output }
  elif command -v wl-copy &>/dev/null; then
    pbcopy() { wl-copy }
    pbpaste() { wl-paste }
  fi
fi

# ─── Secrets ──────────────────────────────────────────────────────────────────
[[ -f "$HOME/.zsh_secret" ]] && source "$HOME/.zsh_secret"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nambrosini/.lmstudio/bin"
# End of LM Studio CLI section


# Local LLM setup (vllm-mlx + pi)
alias pi-study='pi --model local/study --system-prompt "$(cat ~/.pi/agent/prompts/tutor.md)"'
alias pi-code='pi --model local/code --system-prompt "$(cat ~/.pi/agent/prompts/coder.md)"'
alias llm-status='curl -s http://127.0.0.1:8080/v1/status | python3 -c "import json,sys; d=json.load(sys.stdin)[\"model_manager\"]; [print(m[\"id\"], m[\"status\"]) for m in d[\"models\"]]"'
