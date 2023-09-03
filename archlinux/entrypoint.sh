#!/bin/bash

sudo groupmod -o -g $AUDIO_GID audio
sudo groupmod -o -g $VIDEO_GID video
if [ $GID != $(echo `id -g wechat`) ]; then
    sudo groupmod -o -g $GID wechat
fi
if [ $UID != $(echo `id -u wechat`) ]; then
    sudo usermod -o -u $UID wechat
fi
sudo usermod -aG video wechat

echo "启动 $APP"

"/opt/apps/com.qq.weixin.deepin/files/run.sh"

sleep 300

while test -n "`pidof WeChat.exe`"
do
    sleep 60
done
echo "退出"


