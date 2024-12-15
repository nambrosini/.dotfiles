# Configure .dotfiles repo
function config
    /usr/bin/git --git-dir $HOME/.dotfiles/ --work-tree=$HOME $argv
end
# shortcut
function ls 
    eza --icons --group-directories-first $argv
end

function ll 
    ls -l $argv
end
function la 
    ls -la $argv
end
function f 
    fuck $argv
end
function k 
    kubectl $argv
end
function kctl 
    kubectl $argv
end
function redpanda 
    /opt/redpanda/Redpanda-Console-SC.sh $argv
end
function grep 
    command grep --color $argv
end
function cat 
    bat $argv
end
function vim 
    nvim $argv
end
