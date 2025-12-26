#!/bin/sh

IP=$1
PORT=$2
TYPE=$3

if [ -z "$IP" ] || [ -z "$PORT" ]; then
	echo "错误: IP或端口为空"
	exit 1
fi

PROXY_URL="http://$IP:$PORT"
if [ "$TYPE" = "socks5" ]; then
    PROXY_URL="socks5://$IP:$PORT"
fi

export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"

# echo "Testing connection via $PROXY_URL..." >> /tmp/proxy-upgrade.log

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 https://www.google.com)

if [ "$HTTP_CODE" = "200" ]; then
	echo "连接成功 (HTTP 200)"
	exit 0
else
	echo "连接失败 (状态码: $HTTP_CODE)"
	exit 1
fi
