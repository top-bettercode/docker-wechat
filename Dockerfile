FROM bestwu/wine:i386
LABEL maintainer='Xin Zhou <x_zhou6@yahoo.com>'

RUN echo 'deb https://mirrors.aliyun.com/deepin stable main non-free contrib' > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends deepin.com.wechat && \
    apt-get -y autoremove --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && \
    find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && \
    find /usr/share/man -type f -delete

COPY files.7z /tmp/files.7z

RUN set -xe && \
    mv /tmp/files.7z /opt/deepinwine/apps/Deepin-WeChat/files.7z

ENV APP=WeChat \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000

RUN groupadd -o -g $GID wechat && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/wechat" -m -o -u $UID -g wechat -G audio,video wechat && \
    mkdir /WeChatFiles && \
    chown -R wechat:wechat /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/wechat/WeChat Files" && \
    sed -i 's/WeChat.exe" &/WeChat.exe"/g' "/opt/deepinwine/tools/run.sh"

VOLUME ["/WeChatFiles"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
