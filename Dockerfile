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

# Set up supervisord configuration to run everything cleanly on port 10000
# (Render requires your application to listen on a port, and defaults to 10000)
RUN echo '[supervisord]\nnodaemon=true\n\n\
[program:xvfb]\ncommand=Xvfb :1 -screen 0 1280x720x16\n\n\
[program:openbox]\ncommand=openbox-session\nenvironment=DISPLAY=:1\n\n\
[program:x11vnc]\ncommand=x11vnc -display :1 -nopw -forever -shared\n\n\
[program:novnc]\ncommand=websockify --web /usr/share/novnc 10000 localhost:5900\n' > /etc/supervisord.conf

EXPOSE 10000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
