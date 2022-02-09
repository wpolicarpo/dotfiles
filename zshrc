ZSH_BASE=$HOME/.dotfiles

source $ZSH_BASE/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git

case `uname` in
  Darwin)
  ;;
  Linux)
  ;;
esac

antigen theme robbyrussell

antigen apply

source ~/.zsh_aliases

if [ -f ~/.zsh_aliases_local ]; then
    source ~/.zsh_aliases_local
fi
