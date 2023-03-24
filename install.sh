sudo apt-get update
sudo apt-get install -y jq


bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta


json=$(curl -s https://raw.githubusercontent.com/sajjaddg/xray-reality/master/config.json)

keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
json=$(echo "$json" | jq --arg pk "$pk" '.inbounds[0].streamSettings.realitySettings.privateKey = $pk')


uuid=$(xray uuid)
json=$(echo "$json" | jq --arg uuid "$uuid" '.inbounds[0].settings.clients[0].id = $uuid')


echo "$json" | sudo tee /usr/local/etc/xray/config.json >/dev/null

# Restart xray service
sudo service xray restart

# Print public key for user
echo "SNI: yahoo.com"
echo "shortID: 6ba85179e30d4fc2"
echo "network: h2"
echo "security: reality"
echo "Public Key: $pub"
echo "UUID: $uuid"