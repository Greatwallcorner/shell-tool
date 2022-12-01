#! /bin/bash

dir="/usr/lib/shell-tool"
env="/etc/environment"

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

show_help_info(){
    echo "----------------"
    echo "输入shtool使用本工具"
    echo "----------------"
}


_execute(){
    . "$dir/$@"
}

# 删除文件中的一行
# 参数：关键字 文件
delete_line_in_file(){
    num=$(cat $2 | grep -n $1 | cut -d ":" -f 1)
    [ $num ] && sed -i $num\d $2 && echo "删除文件：$2 中的第$num行 关键字:$1"
}

config_proxy(){
    [ proxy=$(cat $env | grep ALL_PROXY) ] && echo "已有代理：$proxy"
    read -p "请输入代理端口:" port
    read -p "请输入协议[http/socks5]:" proto
    if [ ! $proto = 'http' || ! $proto = "socks5" ]; then
        echo "输入错误"
        exit 1
    fi
    ip=$(cat /etc/resolv.conf| grep nameserver | cut -d " " -f 2)
    echo ALL_PROXY=$proto://$ip$port >> $env
}

installBaseTool(){
    echo "建议先执行镜像配置"
    $cmd install -y python3 python3-pip git busybox npm vim
    # 配置镜像
    pip3 config set global.index_url 'https://mirrors.aliyun.com/pypi/simple/'
    pip3 config set install.trusted-host 'mirrors.aliyun.com'
    npm config set registry http://registry.npmmirror.com
}

install_shell_tool(){
    is_installed git
    [ -d $dir ] && rm -rf $dir
    mkdir -p $dir 
    git clone -b main https://github.com/Greatwallcorner/shell-tool.git $dir --depth=1
    chmod -R +x $dir
    #添加环境变量
    if [ ! "$(cat /root/.profile | grep shtool)" ]; then
        echo "alias shtool=$dir/init/init.sh" >> $env
        echo "PATH=$PATH:$dir/tool" >> $env
        source /etc/environment
    fi
    show_help_info
    . $dir/init/init.sh
}

uninstall_shell_tool(){
    # 删除环境变量
    echo "删除环境变量"
    delete_line_in_file "shtool" $env
    delete_line_in_file "shell-tool" $env
    # lineNumber=$(cat /etc/environment | grep -n "shtool" | cut -d ":" -f 1)
    # [ $lineNumber ] && sed -i $lineNumber\d $env
    rm -rf $dir > /dev/null
    echo "删除目录:$dir"
}

# 安装目录 /usr/lib/shell-tool
if [ ! -d $dir ] || [ ! -d $dir/init ];then
    install_shell_tool
    exit 1
fi
[ ! -d $dir/init ] && exit 1
echo "------------"
echo "1. 配置镜像源"
echo "2. 配置zsh"
echo "3. 安装基础工具"
echo "4. 卸载本工具"
echo "5. 展示工具列表"
echo "6. wsl配置代理"
read -p "请输入编号：" -d$'\n' num
case $num in
1) _execute init/config_pm_mirror.sh
;;
2) _execute init/install_zsh.sh
;;
3) installBaseTool
;;
4) uninstall_shell_tool
;;
5) ls $dir/tool
;;
6) config_proxy
;;
esac




