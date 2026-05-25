FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install lightweight XFCE core, TigerVNC, noVNC, and utilities (WITHOUT systemd/snapd)
RUN apt-get update && apt-get install --no-install-recommends -y \
    xfce4 \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    chromium-browser \
    curl \
    git \
    net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Point the default noVNC root directly to the login file layout
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Render requires our web server to listen strictly on port 10000
EXPOSE 10000

# Fix the string escaping and route traffic directly through port 10000
CMD bash -c "\
    vncserver :1 -localhost no -SecurityTypes None -geometry 1280x720 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=NP' -x509 -days 365 -nodes -out /tmp/self.pem -keyout /tmp/self.pem && \
    websockify --web=/usr/share/novnc/ --cert=/tmp/self.pem 10000 localhost:5901 \
"
