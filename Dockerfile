FROM golang:alpine as builder
COPY *.go /go/src/github.com/nektro/andesite/
RUN apk add git \
 && go get -d -v github.com/nektro/andesite \
 && CGO_ENABLED=0 go install -a \
    -installsuffix cgo \
    -ldflags="-s -w" \
    github.com/nektro/andesite

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/andesite /bin/
COPY /www /root/www
WORKDIR /root
VOLUME [ "/root" ]
CMD ["/bin/andesite"]
