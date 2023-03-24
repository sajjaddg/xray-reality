
# Update package index and install dependencies
sudo apt-get update
sudo apt-get install -y jq
sudo apt-get install -y openssl

# Install Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta

# Load the original JSON configuration file
json=$(curl -s https://raw.githubusercontent.com/sajjaddg/xray-reality/master/config.json)

# Generate public-private key pair
keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')

# Modify the JSON configuration file
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)
newJson=$(echo "$json" | jq \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    '.inbounds[0].streamSettings.realitySettings.privateKey = $pk | 
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')

# Write the modified configuration back to the file
echo "$newJson" | sudo tee /usr/local/etc/xray/config.json >/dev/null

# Restart the Xray service
sudo service xray restart

# Print out configuration information
echo "SNI: yahoo.com"
echo "Short ID: $shortId"
echo "Network: h2"
echo "Security: reality"
echo "Public Key: $pub"
echo "UUID: $uuid"

# Done!
exit 0
