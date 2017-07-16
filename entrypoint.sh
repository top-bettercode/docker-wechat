#!/bin/bash

user="$USER"  
userhome="/root"

sed -i "s/:$AUDIO_GID:/:11$AUDIO_GID:/" /etc/group
sed -i "s/:$VIDEO_GID:/:11$VIDEO_GID:/" /etc/group
groupmod -g $AUDIO_GID audio
groupmod -g $VIDEO_GID video

#create group if not exists  
egrep "^$group" /etc/group >& /dev/null  
if [ $? -ne 0 ]  
then  
    groupadd -g $GID $user  
fi  
#create user if not exists  
egrep "^$user" /etc/passwd >& /dev/null  
if [ $? -ne 0 ]  
then  
    useradd -d "/home/$user" -u $UID -m -G audio,video $user
fi

if [ "$user"x != "root"x ]; then
    userhome="/home/$user"
fi

if [ ! -e "/opt/deepinwine/apps/Deepin-$APP/Initialized" ]; then
    echo "初始化用户"
    chown -R "$user:$user" /WeChatFiles
    if [ ! -e "$userhome/WeChat Files" ]; then
        ln -s "/WeChatFiles" "$userhome/WeChat Files"
    fi
    touch /opt/deepinwine/apps/Deepin-$APP/Initialized
fi

echo "use:$user"
su - "$user" <<EOF
if [ "$1" ]; then
    echo "deepin-wine $1"
    deepin-wine $1
else
    echo "启动 $APP"
    /run.sh
fi

exit 0
EOF