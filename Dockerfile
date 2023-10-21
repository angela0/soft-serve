FROM alpine:latest
RUN apk update && apk add --update git bash && rm -rf /var/cache/apk/*
