FROM nginx:1.13.12-alpine
WORKDIR /usr/share/nginx/html

RUN mkdir -p /etc/nginx/snippets

COPY nginx.conf /etc/nginx/nginx.conf
COPY self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ssl-params.conf /etc/nginx/snippets/ssl-params.conf

COPY private.key /etc/ssl/private.key
COPY private.crt /etc/ssl/private.crt
COPY private.pem /etc/ssl/private.pem
