file_save_path='/mnt/f/bili'
cd `dirname $0`

config_save_path(){
    read -p "请配置下载文件保存地址:" file_save_path
    if [ -d $file_save_path ];then
    sed -i "1d" tool/youget.sh
        sed -i "1i file_save_path='$file_save_path'" tool/youget.sh
        echo "保存成功"
    else
        while true;
        do
        read -p "目录不存在 是否创建-($file_save_path)[y/n]:" isCreate
        if [ $isCreate = 'y' ]; then
         mkdir -p $file_save_path
         echo "目录创建成功"
         break;
         elif [ $isCreate = 'n' ]; then
         break
         else 
         echo '输入错误 请重新输入'
         fi
         done
    fi
}

 ask_install(){
    read -p "是否安装you-get及其依赖[y]" isInstall
    [ -z $isInstall ] && [ $isInstall != 'y'] && exit 1
    . init/pmIs.sh
    $cmd install -y ffmpeg 
    pip3 install -y you-get
 }

download(){
    [ ! $(command -v you-get) ] && echo "you-get未安装" && ask_install
    read -p "请输入视频地址:" url
    prefix="you-get -o $file_save_path --no-caption -d -a"
    echo $(pwd)
    [ -f "$(pwd)/cookies.txt" ] && command="$prefix -c $(pwd)/cookies.txt "
    echo "命令:$command$url"
    $command$url 2>&1
}

set_cookies(){
    local dir=$(pwd)
    # echo "pwd:$dir"
    # read -p "请输入cookies:" cookies
    # if [ -f "$dir/cookies.txt" ];then
    #     echo "cookies文件已存在, 删除"
    #     rm -f 'cookies.txt'
    # fi
    # echo "新建cookies文件"
    # echo $cookies > cookies.txt
    read -p "请输入cookies路径:" cookie_path
    [ -f $cookie_path ] && echo "文件存在" && cp $cookie_path "$dir"
    echo "复制文件到：$dir"
}

[ -z $file_save_path ] &&  config_save_path
if [ ! -z $1 ];then
 case $1 in
 '-h') 
    echo
    echo "usage: \n -setPath 配置文件下载目录"
    echo "-h 看到本信息"
    echo "-showPath 展示当前下载文件夹"
    echo "-setCookies 设置cookies"
    echo 
    you-get -h
    ;;
    '-setPath')
    config_save_path
    ;;
    '-showPath')
    echo "当前下载地址:$file_save_path"
    ;;
    '-setCookies')
        set_cookies
        ;;
    '-c')
    cookie=$2
    download
    ;;
    *)
    echo "未知参数:$1"
 esac
 exit 1
 fi
 download

