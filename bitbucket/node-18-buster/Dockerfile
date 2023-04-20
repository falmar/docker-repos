FROM node:18.14-slim
RUN apt-get update \
    && apt-get install -y git curl ca-certificates docker-compose yarn apt-transport-https wget gnupg \
    && sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
    && sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' \
    && apt-get update \
    && apt-get install -y dart \
    && rm -rf /var/lib/apt/lists/*
