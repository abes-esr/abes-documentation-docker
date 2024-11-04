# Use Ubuntu latest as the base image
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install OpenSSH Server and vim
RUN apt-get update && \
    apt-get install -y openssh-server vim openssl && \
    rm -rf /var/lib/apt/lists/*

# Expose the SSH port
EXPOSE 22

# Run SSHD on container start
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
