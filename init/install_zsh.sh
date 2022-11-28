#! /bin/bash

install_autojump(){
    echo '安装autojump插件'
    git clone http://github.com/wting/autojump.git
    cd autojump
    ./install.py or ./uninstall.py
}

echo 
echo '开始安装zsh...'
echo $cmd
echo $(sudo $cmd -y install zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
install_autojump


