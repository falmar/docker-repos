FROM node:10.15.3-alpine
RUN apk --no-cache add openssh git curl ca-certificates py-pip \
    && npm install -g yarn \
    && pip install docker-compose==1.23
