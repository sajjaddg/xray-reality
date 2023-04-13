#!/bin/bash

# Update package index and install dependencies
sudo apt-get update
sudo apt-get install -y jq openssl qrencode

curl -s https://raw.githubusercontent.com/sajjaddg/xray-reality/master/default.json > config.json

# Extract the desired variables using jq
name=$(jq -r '.name' config.json)
email=$(jq -r '.email' config.json)
path=$(jq -r '.path' config.json)

# Prompt user for custom port and SNI values
read -p "Enter a custom port (default $((port:=$(jq -r '.port' config.json)))): " custom_port
read -p "Enter a custom SNI (default $((sni:=($(jq -r '.sni' config.json))))): " custom_sni

port=${custom_port:-$port}
sni=${custom_sni:-$sni}


bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta

json=$(curl -s https://raw.githubusercontent.com/sajjaddg/xray-reality/master/config.json)

keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
serverIp=$(curl -s ipv4.wtfismyip.com/text)
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)

url="vless://$uuid@$serverIp:$port?type=http&security=reality&encryption=none&pbk=$pub&fp=chrome&path=$path&sni=$sni&sid=$shortId#$name"

newJson=$(echo "$json" | jq \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    --arg port "$port" \
    --arg sni "$sni" \
    --arg path "$path" \
    --arg email "$email" \
    '.inbounds[0].port= '"$(expr "$port")"' |
     .inbounds[0].settings.clients[0].email = $email |
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.dest = $sni + ":443" |
     .inbounds[0].streamSettings.realitySettings.serverNames += ["'$sni'", "www.'$sni'"] |
     .inbounds[0].streamSettings.realitySettings.privateKey = $pk |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')

echo "$newJson" | sudo tee /usr/local/etc/xray/config.json >/dev/null
sudo systemctl restart xray

# Print URL & QR code
echo "$url"
echo "QR code:"
qrencode -s 120 -t ANSIUTF8 "$url"
qrencode -s 50 -o qr.png "$url"

exit 0
