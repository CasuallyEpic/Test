FROM alpine:3.19

# Install lightweight Openbox window manager, Xvfb virtual frame screen, x11vnc, noVNC, and utilities
RUN apk add --no-cache \
    openbox \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    curl \
    git \
    net-tools \
    iputils \
    xvfb-run \
    ttf-dejavu

# Configure noVNC web layout paths to point index directly to vnc.html
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Expose port 10000 for Render routing
EXPOSE 10000

# Write a single structural entrypoint script that enforces perfect step-by-step launch timing
RUN echo -e '#!/bin/sh\n\
echo "Starting Virtual Framebuffer..."\n\
Xvfb :1 -screen 0 1280x720x16 &\n\
sleep 2\n\n\
echo "Starting Window Manager..."\n\
DISPLAY=:1 openbox-session &\n\
sleep 1\n\n\
echo "Starting X11 VNC Server..."\n\
x11vnc -display :1 -nopw -forever -shared -localhost -rfbport 5900 &\n\
sleep 2\n\n\
echo "Launching noVNC WebSocket Bridge on Render Port 10000..."\n\
websockify --web /usr/share/novnc 10000 127.0.0.1:5900\n' > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
EXPOSE 10000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
