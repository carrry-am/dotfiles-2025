# Warp Terminal Configuration
# Optimized zsh config for Warp (zprezto/powerlevel10k removed)

# =============================================================================
# Basic zsh configuration
# =============================================================================

# Enable completion system
autoload -U compinit && compinit

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_SPACE      # Don't record entries starting with space
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_VERIFY            # Show command with history expansion to user before running it
setopt EXTENDED_HISTORY       # Save timestamp of command and duration

# Directory navigation
setopt AUTO_CD                # Auto change to a directory without typing cd
setopt AUTO_PUSHD             # Make cd push old directory to directory stack
setopt PUSHD_IGNORE_DUPS      # Don't push multiple copies of same directory

# Completion improvements
setopt COMPLETE_IN_WORD       # Complete from both ends of a word
setopt ALWAYS_TO_END          # Move cursor to end if word had one match

# =============================================================================
# Environment Variables
# =============================================================================

# Path settings
PATH="$PATH:~/bin"

# ls color settings (your existing settings)
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"

# Editor
export EDITOR='vim'
export LANG=en_US.UTF-8

# pnpm (your existing settings)
export PNPM_HOME="/Users/miyataasami/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# =============================================================================
# Aliases (your existing + some additions)
# =============================================================================

# Basic aliases
alias ll="ls -al"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."

# Grep with color
alias grep="grep --color=auto"

# vless (your existing setting)
alias vless="/usr/share/vim/vim90/macros/less.sh"

# Git aliases (your existing + additions)
alias gst="git status"
alias gb="git branch"
alias gdiff="git diff"
alias glog="git log --oneline --graph --decorate"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Utility aliases
alias relogin='exec $SHELL -l'
alias cs="cursor"

# New useful aliases for development
alias ports="lsof -i -P -n | grep LISTEN"
alias myip="curl -s http://whatismyip.akamai.com/"
alias reload="source ~/.zshrc"

# =============================================================================
# Functions
# =============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
killport() {
    if [ $# -eq 0 ]; then
        echo "Usage: killport <port_number>"
        return 1
    fi
    lsof -ti:$1 | xargs kill -9
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =============================================================================
# Peco Integration (your existing settings)
# =============================================================================

# 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

# 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr

# ブランチを簡単切り替え。git checkout lbで実行できる
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

# =============================================================================
# External Tools Integration
# =============================================================================

# asdf (your existing setting)
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

# =============================================================================
# Additional Key Bindings
# =============================================================================

# Use emacs key bindings
bindkey -e

# Better word navigation
bindkey '^[[1;5C' forward-word                    # Ctrl+Right
bindkey '^[[1;5D' backward-word                   # Ctrl+Left

# =============================================================================
# Startup Message
# =============================================================================

echo "🚀 Warp + Simple zsh config loaded!"
echo "💡 Use 'reload' to refresh this config"
