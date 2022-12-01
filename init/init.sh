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

is_installed(){
    echo "$1"
    [ -z $(command -v $1) ] && $cmd install $1
}


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

dir="/usr/lib/shell-tool"

install_shell_tool(){
    is_installed git
    [ -d $dir ] && rm -rf $dir
    mkdir -p $dir 
    git clone -b main https://github.com/Greatwallcorner/shell-tool.git $dir --depth=1
    chmod +x $dir/**
    . $dir/init/init.sh
}

uninstall_shell_tool(){
    rm -rf $dir
    echo "删除目录:$dir"
}

# 安装目录 /usr/lib/shell-tool
if [ ! -d /usr/lib/shell-tool ] || [ ! -d /usr/lib/shell-tool/init ];then
    install_shell_tool
    exit 
fi
[ ! -d /usr/lib/shell-tool/init ] && exit 1
echo "------------"
echo "1. 配置镜像源"
echo "2. 配置zsh"
echo "3. 安装基础工具"
echo "4. 卸载本工具"
read -p "请输入编号：" -d$'\n' num
case $num in
1) _execute config_pm_mirror.sh
;;
2) _execute install_zsh.sh
;;
3) installBaseTool
;;
4) uninstall_shell_tool
;;
esac




