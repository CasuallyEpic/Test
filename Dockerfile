FROM alpine:3.19

# Install ttyd, native tools, and standard shell utilities
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

# Render requires traffic on port 10000
EXPOSE 10000

# Start ttyd on port 10000 running bash natively
# Protected with Username: admin | Password: mysecurepass
CMD ["ttyd", "-p", "10000", "-W", "-i", "0.0.0.0", "-c", "admin:mysecurepass", "/bin/bash"]
