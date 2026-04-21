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
alias zp="vim ~/.zprofile"
alias zrc="vim ~/.zshrc"
alias zreload="source ~/.zshrc"
alias zeload="source ~/.zprofile"

# Shell tool replacements
alias ls='eza --icons'
alias cat='bat'

# Auto-ls on dir change
chpwd() { eza --icons }

# Tool integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"

# oh-my-posh prompt
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config "$POSH_THEME")"
fi
