#!/bin/sh
set -eu
R="$HOME/dotfiles/snorlax"
link() { src="$R/$1"; dst="$2"
  [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ] && return
  if [ -e "$dst" ] && [ ! -e "$src" ]; then mkdir -p "$(dirname "$src")"; mv "$dst" "$src"; fi
  [ -e "$dst" ] && mv "$dst" "$dst.bak.$(date +%s)"
  ln -s "$src" "$dst"; echo "linked $dst -> $src"; }
for t in btop cava fastfetch kitty lazygit nvim ohmyposh palette yazi zellij; do link "$t" "$HOME/.config/$t"; done
for t in aerospace karabiner sketchybar; do link "_macos/$t" "$HOME/.config/$t"; done
link .zshrc "$HOME/.zshrc"; link .screenrc "$HOME/.screenrc"

cd ~/dotfiles && chmod +x link.sh && ./link.sh
ls -la ~/.config | grep -- '->'
grep -rIE 'gh[pousr]_|github_pat_|api[_-]?key|token' snorlax/
