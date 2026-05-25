FROM alpine:3.19

# Install lightweight Openbox window manager, noVNC, and network utilities
RUN apk add --no-cache \
    openbox \
    xvfb \
    x11vnc \
    novnc \
    supervisor \
    curl \
    git \
    net-tools \
    iputils \
    busybox-extras

# Configure noVNC web layout paths
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Set up supervisord configuration with the mandatory [supervisord] block
RUN echo -e '[supervisord]\n\
nodaemon=true\n\
user=root\n\n\
[program:xvfb]\n\
command=Xvfb :1 -screen 0 1280x720x16\n\n\
[program:openbox]\n\
command=openbox-session\n\
environment=DISPLAY=:1\n\n\
[program:x11vnc]\n\
command=x11vnc -display :1 -nopw -forever -shared\n\n\
[program:novnc]\n\
command=websockify --web /usr/share/novnc 10000 localhost:5900\n' > /etc/supervisord.conf

EXPOSE 10000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
