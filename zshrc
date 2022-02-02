ZSH_BASE=$HOME/dotfiles

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