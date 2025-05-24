ARG BUILDX_GO_VERSION=1.24
ARG BUILDX_ALPINE_VERSION=3.21

FROM golang:$BUILDX_GO_VERSION-alpine AS builder
WORKDIR /go-app
COPY ./hostname/go.mod ./hostname/go.sum /go-app/
COPY ./hostname/main.go /go-app/
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /main /go-app/main.go

FROM alpine:$BUILDX_ALPINE_VERSION
RUN apk add --no-cache ca-certificates curl
COPY --from=builder /main /main
COPY ./hostname/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/main"]
