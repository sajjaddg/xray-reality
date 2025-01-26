#!/bin/bash

# Only modified section - argument handling for JSON URL
json_url="https://raw.githubusercontent.com/sajjaddg/xray-reality/master/config.json"
while [[ $# -gt 0 ]]; do
    case $1 in
        --url) json_url="$2"; shift 2 ;;
        --) shift; break ;;
        *) shift ;;
    esac
done

# Original script continues unchanged below
# --------------------------------------------------
sudo apt-get update
sudo apt-get install -y jq openssl qrencode

curl -s https://raw.githubusercontent.com/sajjaddg/xray-reality/master/default.json > config.json

name=$(jq -r '.name' config.json)
email=$(jq -r '.email' config.json)
port=$(jq -r '.port' config.json)
sni=$(jq -r '.sni' config.json)
path=$(jq -r '.path' config.json)

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --version v1.8.23

# Modified JSON line (now uses variable)
json=$(curl -s "$json_url")

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

echo "$url"
qrencode -s 120 -t ANSIUTF8 "$url"
qrencode -s 50 -o qr.png "$url"

exit 0