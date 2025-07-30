if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

# Source stuff
source $HOME/.config/fish/conf.d/starship.fish

# Setup brew
if test -f /usr/local/bin/brew
    eval "$(/usr/local/bin/brew shellenv)"
end
set -gx EDITOR nvim

# setup stuff
set -U fish_user_paths "$HOME/.zig" $fish_user_paths
set -U XDG_CONFIG_HOME "$HOME/.config"


function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience
thefuck --alias | source
zoxide init fish --cmd cd | source

fish_add_path /Users/nambrosini/.spicetify
