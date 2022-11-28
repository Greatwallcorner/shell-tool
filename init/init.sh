#! /bin/bash
# 设置包管理器镜像
cmd="apt-get"
if [[ $(command -v yum) ]];then
    cmd='yum'
elif [[ $(command -v apt) ]];then
    cmd='apt'
elif [[ $(command -v pacman) ]];then
    cmd='pacman'
fi


_execute(){
    local currentDir=$(pwd)
    . "$currentDir/$@"
}

installBaseTool(){
    echo "建议先执行镜像配置"
    $cmd install -y python3 python3-pip git busybox npm vim
    # 配置镜像
    pip3 config set global.index_url 'https://mirrors.aliyun.com/pypi/simple/'
    pip3 config set install.trusted-host 'mirrors.aliyun.com'
    npm config set registry http://registry.npmmirror.com
}

echo "------------"
echo "1. 配置镜像源"
echo "2. 配置zsh"
echo "3. 安装基础工具"
read -p "请输入编号：" -d$'\n' num
case $num in
1) _execute config_pm_mirror.sh
;;
2) _execute install_zsh.sh
;;
3) installBaseTool
esac




