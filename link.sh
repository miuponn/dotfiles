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
# no-attribution commit-msg hook (gitignored, see snorlax/git/hooks/README.md)
if [ -x "$R/git/hooks/commit-msg" ]; then
  git -C "$HOME/dotfiles" config core.hooksPath snorlax/git/hooks
  for r in "$HOME/repos/blog-site" "$HOME/nix-config" "$HOME/repos/qmk_firmware" "$HOME/repos/base16-grove-scheme" "$HOME/repos/ascii-stats"; do
    [ -d "$r/.git" ] && ln -sfn "$R/git/hooks/commit-msg" "$r/.git/hooks/commit-msg"
  done
else
  echo "skip: $R/git/hooks/commit-msg missing (local only), see snorlax/git/hooks/README.md"
fi

cd ~/dotfiles && chmod +x link.sh && ./link.sh
ls -la ~/.config | grep -- '->'
grep -rIE 'gh[pousr]_|github_pat_|api[_-]?key|token' snorlax/
