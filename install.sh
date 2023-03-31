# Update package index and install dependencies
sudo apt-get update
sudo apt-get install -y jq
sudo apt-get install -y openssl
sudo apt-get install -y qrencode

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta

json=$(curl -s https://raw.githubusercontent.com/sajjaddg/xray-reality/master/config.json)

keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
serverIp=$(curl -s ifconfig.me)
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)
url="vless://$uuid@$serverIp:443?path=%2F&security=reality&encryption=none&pbk=$pub&fp=chrome&type=http&sni=yahoo.com&sid=$shortId#IRVLESS-REALITY-04"

newJson=$(echo "$json" | jq \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    '.inbounds[0].streamSettings.realitySettings.privateKey = $pk | 
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')
echo "$newJson" | sudo tee /usr/local/etc/xray/config.json >/dev/null

sudo service xray restart

echo "$url"

qrencode -s 120 -t ANSIUTF8 "$url"
qrencode -s 50 -o qr.png "$url"

exit 0
