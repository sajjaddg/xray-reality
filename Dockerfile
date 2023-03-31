FROM ubuntu:22.04

LABEL maintainer="admin@samsesh.net"
LABEL version="0.1"
LABEL description="docker image for xray reality from https://github.com/sajjaddg/xray-reality"

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl unzip jq openssl qrencode unzip tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install Xray-core
RUN curl -L -H "Cache-Control: no-cache" -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.0/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/bin/ && \
    rm /tmp/xray.zip && \
    chmod +x /usr/bin/xray
#end 

#install xray-reality
WORKDIR /root/
COPY ./conf.docker.sh ./install.sh
RUN sh install.sh
RUN qrencode -s 50 -o qr.png $(cat test.url)
#end 

ENTRYPOINT ["tail", "-f", "/dev/null"]

EXPOSE 443