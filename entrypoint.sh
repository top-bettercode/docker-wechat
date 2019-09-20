#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video
if [ $GID != $(echo `id -g wechat`) ]; then
    groupmod -o -g $GID wechat
fi
if [ $UID != $(echo `id -u wechat`) ]; then
    usermod -o -u $UID wechat
fi
chown wechat:wechat /WeChatFiles

su wechat <<EOF
    echo "启动 $APP"
    "/opt/deepinwine/apps/Deepin-$APP/run.sh"
   sleep 300
EOF

while test -n "`pidof WeChat.exe`"
do
    sleep 60
done
echo "退出"


