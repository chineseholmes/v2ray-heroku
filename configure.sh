#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 64
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json

mkdir /tmp/frpc
curl -L -H "Cache-Control: no-cache" -o /tmp/frpc/frp_${FRP_VERSION}_linux_amd64.tar.gz https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz
tar -xf /tmp/frpc/frp_${FRP_VERSION}_linux_amd64.tar.gz 
mkdir /frpc
cp /tmp/frpc/frp_${FRP_VERSION}_linux_amd64/frpc* /frpc/ 

rm -rf /tmp/frpc

cd /frpc

cat <<-EOF > /frpc/frpc.ini

[common]
protocol = tcp
server_addr = us-la-cn2.sakurafrp.com
server_port = 7000

user = 9o2ntwefismbyr83
token = SakuraFrpClientToken
sakura_mode = true
use_recover = true

tcp_mux = true
pool_count = 1

[herokuv2]
type = tcp

local_ip = 127.0.0.1
local_port = $PORT

use_encryption = 0
use_compression = 0

remote_port = 35907

EOF

/frpc/frpc -c /frpc/frpc.ini
