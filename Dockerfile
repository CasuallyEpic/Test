FROM alpine:3.19

# Install ttyd, bash, and common networking/dev tools
RUN apk add --no-cache \
    ttyd \
    bash \
    curl \
    git \
    net-tools \
    iputils \
    busybox-extras \
    vim

# Set up the terminal environment to support colors cleanly
ENV TERM=xterm-256color
ENV SHELL=/bin/bash

# Render strictly requires traffic on port 10000
EXPOSE 10000

# Start ttyd on port 10000 running bash natively
# Protected with Username: admin | Password: password123
CMD ["ttyd", "-p", "10000", "-W", "-i", "0.0.0.0", "-c", "admin:password123", "/bin/bash"]
