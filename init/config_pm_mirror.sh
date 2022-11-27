#! /bin/bash
cmd=''
# 发行版名称
sys_name=$(sudo cat /etc/os-release | grep ^ID= | cut -d\= -f2| sed 's/"//g')
# 发行版具体代码
sys_code=$(sudo cat /etc/os-release | grep ^VERSION_ID= | cut -d\= -f2| sed 's/"//g')
#系统别名
alias_code=''
#镜像url
url=' http://mirrors.aliyun.com'

if [[ $(command -v yum) ]];then
    cmd='yum'
elif [[ $(command -v apt) ]];then
    cmd='apt'
elif [[ $(command -v pacman) ]];then
    cmd='pacman'
fi
# 版本号选择
# choice
# case $cmd in
# 'yum') mod_yum_mirror()

showInfo(){
    echo "包管理工具:$cmd"
    echo "发行版名称:$sys_name"
    echo "发行版版本号:$sys_code"
    echo "镜像:$url"
}


mod_yum_mirror(){
    # 备份原配置文件
    echo
    if [[ $cmd == 'yum' ]];then
        echo "yum包管理"
        backup_yum_conf
        download_conf
        sudo yum clean all && sudo yum makecache 
    elif [[ $cmd == 'apt' ]];then
        echo "apt包管理"
        # 备份配置
        mv /etc/apt/sources.list /etc/apt/sources.list.backup
        # 复制模板
        cp config/source.list.template /etc/apt/sources.list
        # 修改模板
        distribute=''
        echo $sys_name
        case $sys_name in
        'ubuntu')
            echo "ubuntu mod sources.list"
            case $sys_code in 
            20.4) 
            distribute = 'focal'
            ;;
            18.4)
            distribute = 'bionic'
            ;;
            16.04)
            distribute = 'xenial'
            ;;
            14.04.5)
            distribute = 'trusty'
            ;;
            esac
            sed -i "s/{code}/$distribute/" /etc/apt/sources.list
            sed -i "s/{url}/$url/" /etc/apt/sources.list
            sed -i "s/{distribution}/$sys_name/" /etc/apt/sources.list
        ;;
        'debian')
            echo "debain mod sources.list"
            if [[ $sys_code -le 8 ]]; then
                cp config/sources.list.7-8.debain config/sources.list
            else 
                cp config/sources.list.debain config/sources.list
            fi
            case $sys_code in
            '7') distribute='wheezy'
            ;;
            '8') distribute='jessie'
            ;;
            '9') distribute='stretch'
            ;;
            '10') distribute='buster'
            ;;
            '11') distribute='bullseye'
            ;;
            esac
            sed -i "s!{url}!$url!" config/sources.list
            sed -i "s/{code}/$distribute/" config/sources.list
            sed -i "s/{distribution}/$sys_name/" config/sources.list
            cp config/sources.list /etc/apt/sources.list
            sudo $cmd update
            sudo $cmd install -y apt-transport-https ca-certificates
            sed -i "s!http!https!" config/sources.list
            cp config/sources.list /etc/apt/sources.list
            ;;
        *)
            echo "不支持的系统:$sys_name"

        esac
        sudo apt update
    fi
}

backup_yum_conf(){
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
}

download_conf(){
    case $sys_name in
        'centos') 
        confUrl=''
        # 选择不同发行版的配置地址
            case $sys_code in
            6) confUrl='https://mirrors.aliyun.com/repo/Centos-vault-6.10.repo'
            ;;
            7) confUrl='https://mirrors.aliyun.com/repo/Centos-7.repo'
            ;;
            8) confUrl='https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo'
            ;;
            *)
            echo "code不存在$sys_code"
            esac
        # 下载
        wget -O /etc/yum.repos.d/CentOS-Base.repo $confUrl
        echo "centos yum 配置文件下载完毕"
        ;;
    esac

}

showInfo
mod_yum_mirror