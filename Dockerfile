FROM alpine:latest
RUN apk update && apk add --update git && rm -rf /var/cache/apk/*
