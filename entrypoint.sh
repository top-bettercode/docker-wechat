#!/bin/bash

user="$USER"  
logfile="/root/app.log"

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
    logfile="/home/$user/app.log"
fi

if [ ! -e "/opt/deepinwine/apps/Deepin-$APP/Initialized" ]; then
    echo "初始化用户"
    if [ "$user"x != "root"x ]; then
        chown -R "$user:$user" /WeChatFiles
        if [ ! -e "/home/$user/WeChat Files" ]; then
            ln -s "/WeChatFiles" "/home/$user/WeChat Files"
        fi
    else
        if [ ! -e "/root/WeChat Files" ]; then
            ln -s "/WeChatFiles" "/root/WeChat Files"
        fi
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
    nohup /opt/deepinwine/apps/Deepin-$APP/run.sh >"$logfile" &
    tail -fn 0 "$logfile"
fi

exit 0
EOF