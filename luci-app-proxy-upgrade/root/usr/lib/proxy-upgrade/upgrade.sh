#!/bin/sh

IP=$(uci get proxy-upgrade.settings.proxy_ip)
PORT=$(uci get proxy-upgrade.settings.proxy_port)
TYPE=$(uci get proxy-upgrade.settings.proxy_type)
ENABLED=$(uci get proxy-upgrade.settings.enabled)

if [ "$ENABLED" != "1" ]; then
	echo "Proxy upgrade is disabled."
	echo "Starting normal upgrade..."
	opkg update
	opkg upgrade $(opkg list-upgradable | awk '{print $1}')
	exit 0
fi

if [ -z "$IP" ] || [ -z "$PORT" ]; then
	echo "Error: Proxy configuration missing."
	exit 1
fi

PROXY_URL="http://$IP:$PORT"
if [ "$TYPE" = "socks5" ]; then
    PROXY_URL="socks5://$IP:$PORT"
fi

echo "Setting proxy to $PROXY_URL"
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"

echo "Updating package lists..."
opkg update

echo "Checking for upgrades..."
PACKAGES=$(opkg list-upgradable | awk '{print $1}')

if [ -z "$PACKAGES" ]; then
	echo "No packages to upgrade."
	exit 0
fi

echo "Upgrading packages: $PACKAGES"
opkg upgrade $PACKAGES
