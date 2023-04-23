FROM golang:1.19-alpine AS builder

COPY ./hostname /go-app
RUN CGO_ENABLED=0 go build -o /go-app/hostapp /go-app/main.go

FROM alpine:3.17
COPY --from=builder /go-app/hostapp /hostapp
CMD ["/hostapp"]
