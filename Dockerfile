FROM ubuntu:22.04

# 设置时区
ENV TZ=Asia/Shanghai

# 更新源列表并安装软件包
RUN apt-get update && apt-get install -y \
    wine \
    qemu-kvm \
    fonts-wqy-zenhei \
    xz-utils \
    dbus-x11 \
    curl \
    firefox \
    gnome-system-monitor \
    mate-system-monitor \
    git \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压 noVNC
WORKDIR /root
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz \
    && tar -xvf v1.2.0.tar.gz

# 设置 VNC 密码
RUN mkdir $HOME/.vnc \
    && echo 'haikeheijie' | vncpasswd -f > $HOME/.vnc/passwd \
    && chmod 600 $HOME/.vnc/passwd \
    && chmod 755 $HOME/.vnc

# 设置 VNC 启动命令
RUN echo '#!/bin/bash' > $HOME/.vnc/xstartup \
    && echo 'dbus-launch startxfce4 &' >> $HOME/.vnc/xstartup \
    && chmod 755 $HOME/.vnc/xstartup

# 创建启动脚本
RUN echo '#!/bin/bash' > /haikeheijie.sh \
    && echo 'vncserver :2000 -geometry 1360x768' >> /haikeheijie.sh \
    && echo 'cd /root/noVNC-1.2.0' >> /haikeheijie.sh \
    && echo './utils/launch.sh --vnc localhost:2000 --listen 8900' >> /haikeheijie.sh \
    && chmod 755 /haikeheijie.sh

EXPOSE 8900

CMD ["/haikeheijie.sh"]
