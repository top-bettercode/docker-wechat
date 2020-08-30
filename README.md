个人定制版，解决Ubuntu 20.04下wine system tray的显示错误和不能显示独立消息窗口的bug

在如下系统中测试通过：
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.1 LTS"

[![Docker Image](https://img.shields.io/badge/docker%20image-available-green.svg)](https://hub.docker.com/r/bestwu/wechat/)

本镜像基于[深度操作系统](https://www.deepin.org/download/)

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

### 运行

wechat_run.sh

如果中文输入法不是ibus，请自行编辑wechat_run.sh把所有ibus替换成系统中输入法，一般来说，ibus和fcitx其中一个。

