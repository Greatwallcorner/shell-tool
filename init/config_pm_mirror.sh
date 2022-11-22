#! /bin/bash
cmd=''
# 发行版名称
sys_id = cat /etc/os-release | grep ^ID= | cut -d\= -f2| sed 's/"//g'

if [[ command -v yum ]];then
    cmd = 'yum'
elif [[ command -v apt]];then
    cmd = 'apt'
elif [[ command -v pacman]];then
    cmd = 'pacman'

# 版本号选择
choice
case $cmd in
'yum') mod_yum_mirror()






mod_yum_mirror(){
    # 备份原配置文件

    # 复制新的配置
}