FROM node:12.11.1-alpine
RUN apk --no-cache add openssh git curl ca-certificates py-pip make g++ python-dev libffi-dev openssl-dev gcc libc-dev \
    && npm config set unsafe-perm true \
    && npm install -g yarn \
    && pip install docker-compose
