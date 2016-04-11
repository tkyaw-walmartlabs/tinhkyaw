#!/usr/bin/env bash
if [[ $# -ne 1 ]]
then
  echo "Usage: $0 <suffix>"
  exit 1
fi
SUFFIX="${1}"
SNAPSHOT_DIR="${HOME}/Dropbox/Shared/Snapshots"
WD=$(pwd)
DIR=$(dirname "$(greadlink -f "$0")")
cd ${DIR}
GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
PKG_DIR="${GIT_ROOT_DIR}/packages"
brew list > ${SNAPSHOT_DIR}/brew${SUFFIX}.txt
brew cask list > ${SNAPSHOT_DIR}/cask${SUFFIX}.txt
brew cask list > ${PKG_DIR}/casks
gem list > ${SNAPSHOT_DIR}/gem${SUFFIX}.txt
pip freeze --local > ${SNAPSHOT_DIR}/pip${SUFFIX}.txt
pip freeze --local > ${PKG_DIR}/pips
cd ${WD}
