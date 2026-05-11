fastfetch

# Env
export ZSH="$HOME/.oh-my-zsh"
export POSH_THEME="$HOME/.config/ohmyposh/grove.yaml"

# disabled omz prompt
ZSH_THEME=""

# OMZ plugins
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Shortcuts
alias zp="nvim ~/.zprofile"
alias zrc="nvim ~/.zshrc"
alias zreload="source ~/.zshrc"
alias zeload="source ~/.zprofile"

# Shell tool replacements
alias ls='eza --icons'
alias cat='bat'

# Auto-ls on dir change
chpwd() { eza --icons }

# oh-my-posh prompt
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config "$POSH_THEME")"
fi

# Zellij session launchers
alias vibe='zellij attach vibe 2>/dev/null || zellij -l vibe -s vibe'
alias code='zellij attach code 2>/dev/null || zellij -l code -s code'
alias dash='zellij attach dash 2>/dev/null || zellij -l dash -s dash'
alias zs='zellij list-sessions'

alias lg='lazygit'

export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/Users/kelly/.spicetify

# lsp-doctor after every brew batch
brew() {
  command brew "$@"
  local rc=$?
  case "$1" in
    install|upgrade|uninstall|reinstall) lsp-doctor ;;
  esac
  return $rc
}

# Tool integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
