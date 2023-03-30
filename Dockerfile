FROM ubuntu:22.04

LABEL maintainer="admin@samsesh.net"
LABEL version="0.1"
LABEL description="docker image for xray reality from https://github.com/sajjaddg/xray-reality"

#update repo
RUN apt-get update

#install req
RUN apt-get install -y curl unzip jq openssl qrencode

#install xray
RUN curl -LJO https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip
#end 

#install xray-reality
WORKDIR /root/
COPY ./conf.docker.sh ./install.sh
RUN sh install.sh
#end 