FROM golang:1.22.1-alpine AS builder
WORKDIR /go-app
COPY ./hostname/go.mod ./hostname/go.sum /go-app/
COPY ./hostname/main.go /go-app/
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /main /go-app/main.go

FROM alpine:3.19
RUN apk add --no-cache ca-certificates curl
COPY --from=builder /main /main
CMD ["/main"]
