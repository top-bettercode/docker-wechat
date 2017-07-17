FROM bestwu/wine:i386
MAINTAINER Peter Wu <piterwu@outlook.com>

RUN apt-get update && \
    apt-get install -y deepin.com.wechat && \
    apt-get -y autoremove && apt-get clean -y && apt-get autoclean -y && \
    rm -rf var/lib/apt/lists/* var/cache/apt/* var/log/*

ENV APP=WeChat \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000

ADD entrypoint.sh /
ADD run.sh /
RUN chmod +x /entrypoint.sh && \
    chmod +x /run.sh && \
    groupadd -o -g $GID wechat && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/wechat" -m -o -u $UID -g wechat -G audio,video wechat && \
    mkdir /WeChatFiles && \
    chown -R wechat:wechat /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/wechat/WeChat Files"

VOLUME ["/WeChatFiles"]

ENTRYPOINT ["/entrypoint.sh"]