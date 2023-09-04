FROM archlinux:latest
LABEL maintainer='Peter Wu <piterwu@outlook.com>'

ENV APP=WeChat \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000

COPY zh_CN /tmp/
RUN groupadd -o -g $GID wechat && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/wechat" -m -o -u $UID -g wechat -G audio,video wechat && \
    echo "wechat ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir /WeChatFiles && \
    chown -R wechat:wechat /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/wechat/WeChat Files" && \
    echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    sed -i '1i Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist && \
    pacman-key --init && \
    pacman -Syu --noconfirm sudo && \
    mv /tmp/zh_CN /usr/share/i18n/locales/ && \
    sed -i '$a zh_CN.UTF-8 UTF-8' /etc/locale.gen && \
    locale-gen

USER wechat

COPY *.pkg.tar.zst /tmp/
RUN cd /tmp/ && \
    sudo pacman -U --noconfirm \
    lib32-udis86-git-1.7.2.186.g5336633-1-x86_64.pkg.tar.zst \
    deepin-wine-helper-5.1.45_1-1-x86_64.pkg.tar.zst \
    deepin-wine6-stable-6.0.0.46-1-x86_64.pkg.tar.zst \
    deepin-wine-wechat-3.9.0.28-3-x86_64.pkg.tar.zst && \
    sudo pacman -Scc --noconfirm && \
    sudo rm -fr /tmp/* /var/cache/*

ENV LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANG=zh_CN.UTF-8 \
    TZ=UTC-8

VOLUME ["/WeChatFiles"]

ADD entrypoint.sh /
RUN sudo chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]