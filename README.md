# .dotfiles

## Installing your dotfiles onto a new system

```bash
echo ".dotfiles" >> .gitignore
git clone --recurse-submodules --bare git@github.com:nambrosini/.dotfiles.git $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config checkout
```
