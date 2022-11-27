!# /bin/bash
# 设置包管理器镜像
cmd="apt-get"
if [[ $(command -v yum) ]];then
    cmd="yum"
elif [[ $(command -v pkg) ]];then
    cmd="pkg"
elif [[ $(command -v apt-get) ]];then
    cmd="apt-get"
fi

