#!/usr/bin/env bash
DIR=$(dirname $(type -a "$0" | cut -d " " -f 3))
is_quick=false
while getopts q flag
do
  case ${flag} in
    q)
      is_quick=true
      ;;
    ?)
    exit 1
    ;;
  esac
done
shift $(( OPTIND - 1 ))
brew update
brew upgrade
brew upgrade cask
brew cask update
caskroom_path="/usr/local/Caskroom"
for app in $(brew cask list)
do
  ver=$(brew cask info ${app} | head -1 | cut -d " " -f 2)
  if [ $ver == "latest" ]
  then
    if grep -Fxq ${app} "$(readlink ${DIR}/ignored)"
    then
      echo -e "\e[93mIgnoring \e[96m${app}\e[39m"
    else
      if ${is_quick} && grep -Fxq ${app} "$(readlink ${DIR}/slow)"
      then
        echo -e "\e[93mSkipping \e[96m${app} \e[39mupdate for speed"
      else
        echo -e "\e[93mReinstalling \e[39mlatest \e[96m${app}\e[39m"
        brew cask reinstall ${app}
      fi
    fi
  else
    if [ -d "$caskroom_path/${app}/.metadata/${ver}" ]
    then
      echo -e "\e[94mLatest \e[96m${app}: ${ver} \e[39malready installed"
    else
      brew cask reinstall ${app}
    fi
  fi
done
brew cleanup --force
brew linkapps
brew cask cleanup
cleanup-caskroom.sh
brew doctor
gem update --system
gem update
gem cleanup
npm update -g
npm-check -u -g
pip install --upgrade pip setuptools
pip freeze --local | grep -v "^\-e" | cut -d = -f 1  | xargs pip install --no-binary :all: --upgrade
