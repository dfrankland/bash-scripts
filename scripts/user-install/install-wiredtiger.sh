#!/bin/bash -x

source /etc/os-release

case "$ID" in
  debian) export apt=/usr/bin/apt ;;
  ubuntu) export apt=/usr/bin/apt ;;
  centos) export apt=/usr/bin/yum ;;
  fedora) export apt=/usr/bin/yum ;;
  *)      export apt=/usr/bin/apt ;;
esac


function wiredtiger_requirements {
  sudo $apt -y update
  sudo $apt -y install autogen
  sudo $apt -y install autoconf autogen intltool
  sudo $apt -y install libtool
  sudo $apt -y install make
  sudo $apt -y install swig
}


function wiredtiger_install {
  [[ ! -d ~/workspace ]] && mkdir -p ~/workspace
  pushd ~/workspace

  if [ ! -d wiredtiger ] ;then
    git clone git://github.com/wiredtiger/wiredtiger.git
  else
    cd wiredtiger
    git pull
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools} ]] && mkdir -p ${tools}

  cd ~/workspace/wiredtiger
  ./autogen.sh
  ./configure --enable-java --prefix=${tools}/wiredtiger

  make
  make install

  popd

  mkdir -p ~/bin > /dev/null 2>&1
  ln -s ${tools}/wiredtiger/bin/wt ~/bin/wt

  echo $HOME/bin/wt
}

wiredtiger_requirements && wiredtiger_install
