#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script—I will attempt to change to root.\nIf you cannot change to root account this script will terminate." 2>&1

  #attempt to switch to super user
  su

  if [[ $EUID -ne 0 ]]; then
    exit 1
  fi
fi

#find directories
username=$(id -u -n 1000)
builddir=$(pwd)
dotfilesdir=$(find ~ -type d -name '.dotfiles' -print -quit)

# Update packages list
apt-get update

sudo apt-get install $(cat $dotfilesdir/pkglist) -y

#install packates

echo "" 
mkdir -p /home/$username/.config
#create directory for fonts
mkdir -p ~/.local/share/fonts
mkdir -p /home/$username/Pictures/backgrounds

#need to fix this to be less rigid
cp $dotpics/mainbg.png /home/$username/Pictures/backgrounds/

#get go fonts from github
echo "Going to ~/.local/share/fonts to install go fonts" 2>&1

cd ~/.local/share/fonts

curl --remote-name-all -L https://github.com/golang/image/raw/master/font/gofont/ttf/s/{Go-Bold-Italic.ttf,Go-Bold.ttf,Go-Italic.ttf,Go-Medium-Italic.ttf,Go-Medium.ttf,Go-Mono-Bold-Italic.ttf,Go-Mono-Italic.ttf,Go-Mono.ttf,Go-Regular.ttf,Go-Smallcaps-italic.ttf,Go-Smallcaps.ttf}

#go back to directory
cd -

#clear and regenerate font cache
fc-cache -f -v

#link zsh to correct place
~ ln -s -T .config/zsh/.zshrc .zshrc
