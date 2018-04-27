#!/bin/zsh
# Configure tools and dotfiles
#
# Execute this script with the command below:
# \curl -sSL https://raw.githubusercontent.com/wpolicarpo/dotfiles/master/install.sh | bash -s

set -e

function pecho() {
  print -P "%B%F{$1}${2}%f%b"
}

export DOTFILES=~/.dotfiles

#######################################################################################################################
# BEGIN: oh my zsh ####################################################################################################
#######################################################################################################################
pecho "magenta" "### Configuring oh my zsh ###"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#######################################################################################################################
# BEGIN: brew #########################################################################################################
#######################################################################################################################
pecho "magenta" "### Configuring brew ###"

if [ ! -x /usr/local/bin/brew ]
then
  pecho "green" "[+] Installing brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  pecho "yellow" "[!] brew is already installed"
fi

brew update > /dev/null

#######################################################################################################################
# BEGIN: tools ########################################################################################################
#######################################################################################################################
pecho "magenta" "### Configuring tools ###"

TOOLS=(wget node mysql-connector-c)

for tool in "${TOOLS[@]}"
do
  if brew ls --versions ${tool} > /dev/null
  then
    pecho "yellow" "[!] ${tool} is already installed"
  else
    pecho "green" "[+] Installing ${tool}"
    brew install $tool
  fi
done

#######################################################################################################################
# BEGIN: asdf #########################################################################################################
#######################################################################################################################
pecho "magenta" "### Configuring asdf ###"

if ! type "asdf" > /dev/null
then
  pecho "green" "[+] Installing asdf"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
else
  pecho "yellow" "[!] asdf is already installed"
fi

#######################################################################################################################
# BEGIN: Sublime Text 3 ###############################################################################################
#######################################################################################################################
pecho "magenta" "### Configuring Sublime Text ###"

export SUBLIME_PATH=~/Library/Application\ Support/Sublime\ Text\ 3
export SUBLIME_PACKAGES_PATH=$SUBLIME_PATH/Packages/User

if [ ! -d "$SUBLIME_PATH" ]; then
  pecho "red" "[-] Sublime Text 3 is not installed"
fi

pecho "green" "[+] Installing terminal shortcut"
ln -fs /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime

pecho "green" "[+] Installing Package Control"
wget -q https://packagecontrol.io/Package%20Control.sublime-package -O $SUBLIME_PATH/Installed\ Packages/Package\ Control.sublime-package

pecho "green" "[+] Installing user preferences"
ln -fs ${DOTFILES}/sublime/Preferences.sublime-settings ${SUBLIME_PACKAGES_PATH}/Preferences.sublime-settings

pecho "green" "[+] Installing packages"
ln -fs ${DOTFILES}/sublime/Package\ Control.sublime-settings ${SUBLIME_PACKAGES_PATH}/Package\ Control.sublime-settings

pecho "green" "[+] Installing user key bindings"
ln -fs $DOTFILES/sublime/Default\ \(OSX\).sublime-keymap ${SUBLIME_PACKAGES_PATH}/Default\ \(OSX\).sublime-keymap

#######################################################################################################################
# BEGIN: rc files #####################################################################################################
#######################################################################################################################
pecho "magenta" "### Configuring *rc files ###"

for file in ${DOTFILES}/rc/*
do
  pecho "green" "[+] Installing $file"
  ln -fs $file ~/.$(basename $file)
done

