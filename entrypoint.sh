#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video
groupmod -o -g $GID wechat
if [ $UID != $(echo `id -u wechat`) ]; then
    usermod -o -u $UID wechat
fi
chown -R wechat:wechat /WeChatFiles
chown -R wechat:wechat /home/wechat

su wechat <<EOF
if [ "$1" ]; then
    echo "deepin-wine $1"
    deepin-wine $1
else
    echo "启动 $APP"
    /run.sh
fi

exit 0
EOF