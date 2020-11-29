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

# Download and install Frp
mkdir /tmp/frp
curl -L -H "Cache-Control: no-cache" -o /tmp/frp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.34.3/frp_0.34.3_linux_amd64.tar.gz
tar -xzvf /tmp/frp/frp.tar.gz -C /tmp/frp
install -m 755 /tmp/frp/frp_0.34.3_linux_amd64/frpc /usr/local/bin/frpc

# Remove temporary directory
rm -rf /tmp/frp

# Frp new configuration
install -d /usr/local/etc/frp
cat << EOF > /usr/local/etc/frp/frpc.ini

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

# Run Frp
/usr/local/bin/frpc -c /usr/local/etc/frp/frpc.ini
