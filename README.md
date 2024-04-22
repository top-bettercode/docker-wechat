[![Docker Image](https://img.shields.io/badge/docker%20image-available-green.svg)](https://hub.docker.com/r/bestwu/wechat/)

### archlinux

镜像基于[archlinux](https://www.archlinux.org/download/)

第一次运行失败时，进入容器重新运行

```bash
docker exec -it wechat bash
```
```bash docker
/opt/apps/com.qq.weixin.deepin/files/run.sh
```

微信版本：3.9.0

### deepin

镜像基于[深度操作系统](https://www.deepin.org/download/)

微信版本：2.6.8

### 准备工作

允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```

## 查看系统audio gid

```bash
  cat /etc/group | grep audio
```

fedora 26 结果：

```bash
audio:x:63:
```

### 更新

进入docker容器：docker exec -it wechat bash
运行以下命令更新深度软件包：

```bash
apt-get update

apt-get install -y deepin.com.wechat

```

### 运行

### docker-compose

```yml
services:
  wechat:
    image: bestwu/wechat
    container_name: wechat
    ipc: host
    devices:
      - /dev/snd
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /home/peter/WeChatFiles:/WeChatFiles #使用自己用户目录
    environment:
      - DISPLAY=unix$DISPLAY
      - QT_IM_MODULE=fcitx
      - XMODIFIERS=@im=fcitx
      - GTK_IM_MODULE=fcitx
      - AUDIO_GID=63 # 可选 默认63（fedora） 主机audio gid 解决声音设备访问权限问题
      - GID=1000 # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
      - UID=1000 # 可选 默认1000 主机当前用户 uid 解决挂载目录访问权限问题
```

或

```bash
    docker run -d --name wechat --device /dev/snd --ipc="host"\
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/WeChatFiles:/WeChatFiles \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e AUDIO_GID=`getent group audio | cut -d: -f3` \
    -e GID=`id -g` \
    -e UID=`id -u` \
    bestwu/wechat
```
