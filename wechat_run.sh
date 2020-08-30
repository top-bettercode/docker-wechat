#!/bin/bash

test -d $HOME/wine-WeChat || mkdir $HOME/wine-WeChat

cat partfile* > files.7z

docker build --tag docker-wechat:1.0 .

docker run -d  --ipc=host --name wechat --device /dev/snd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME:/HostHome \
    -v $HOME/wine-WeChat:/home/wechat/.deepinwine/Deepin-WeChat \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=ibus \
    -e QT_IM_MODULE=ibus \
    -e GTK_IM_MODULE=ibus \
    -e AUDIO_GID=`getent group audio | cut -d: -f3` \
    -e GID=`id -g` \
    -e UID=`id -u` \
    docker-wechat:1.0

#bestwu/wechat
