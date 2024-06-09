if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Source stuff
source $HOME/.config/fish/conf.d/starship.fish

# Setup brew
eval "$(/opt/homebrew/bin/brew shellenv)"
set -gx EDITOR nvim

function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience
