#!/bin/sh

. /lib/functions.sh

config_load proxy-upgrade

clear_rules() {
    while ip rule show | grep -q "lookup 100"; do
        ip rule del lookup 100
    done
    ip route flush table 100
}

handle_proxy() {
    local config="$1"
    local enabled
    local global_proxy
    local proxy_ip
    
    config_get_bool enabled "$config" enabled 0
    config_get_bool global_proxy "$config" global_proxy 0
    config_get proxy_ip "$config" proxy_ip

    clear_rules

    if [ "$enabled" = "1" ] && [ "$global_proxy" = "1" ] && [ -n "$proxy_ip" ]; then
        # Get LAN subnet
        local LAN_NET=$(ip addr show br-lan | awk '/inet / {print $2}')
        
        # Avoid loop for proxy IP
        ip rule add to "$proxy_ip" lookup main pref 8999
        
        # Avoid local traffic going to proxy
        if [ -n "$LAN_NET" ]; then
            ip rule add to "$LAN_NET" lookup main pref 8998
        fi
        
        # Add route to table 100
        ip route add default via "$proxy_ip" dev br-lan table 100
        
        # Route all traffic to table 100
        ip rule add from all lookup 100 pref 9000
        
        echo "Global Proxy Enabled: via $proxy_ip"
    else
        echo "Global Proxy Disabled"
    fi
}

config_foreach handle_proxy proxy
