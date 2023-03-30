FROM ubuntu:22.04

LABEL maintainer="admin@samsesh.net"
LABEL version="0.1"
LABEL description="docker image for xray reality from https://github.com/sajjaddg/xray-reality"

#update repo
RUN apt-get update

#install req
RUN apt-get install -y curl unzip jq openssl qrencode
