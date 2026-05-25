FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, VNC, noVNC, and standard network utilities
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    curl \
    git \
    net-tools \
    iputils-ping \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV USER=root
ENV HOME=/root
EXPOSE 6080

# Script to clear old locks, set password to "password", and start the web VNC server
RUN echo '#!/bin/sh\n\
rm -rf /tmp/.X11-unix/X1 /tmp/.X1*-lock\n\
mkdir -p /root/.vnc\n\
echo "password" | vncpasswd -f > /root/.vnc/passwd\n\
chmod 600 /root/.vnc/passwd\n\
vncserver :1 -geometry 1280x720 -depth 24\n\
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
