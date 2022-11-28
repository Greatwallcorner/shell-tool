if [[ $(command -v yum) ]];then
    cmd='yum'
elif [[ $(command -v apt) ]];then
    cmd='apt'
elif [[ $(command -v pacman) ]];then
    cmd='pacman'
fi