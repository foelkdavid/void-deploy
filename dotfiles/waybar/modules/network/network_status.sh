#!/bin/bash

# Parse network interfaces using `ip -br a`
network_data=$(ip -br a)

# Check for IP address on the wireless interface (wlp3s0)
wifi_ip=$(echo "$network_data" | grep -E '^wlp3s0\s+UP' | grep -oE '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b')

# Check for IP address on the first wired interface (enp2s0f0)
wired_ip1=$(echo "$network_data" | grep -E '^enp2s0f0\s+UP' | grep -oE '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b')

# Check for IP address on the second wired interface (enp5s0)
wired_ip2=$(echo "$network_data" | grep -E '^enp5s0\s+UP' | grep -oE '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b')

# Check for IP address on the additional wired interface (enp7s0f3u1)
wired_ip3=$(echo "$network_data" | grep -E '^enp7s0f3u1\s+UP' | grep -oE '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b')

# Function to display a list of interfaces and their IPs if --ips is provided
if [[ "$1" == "--ips" ]]; then
    if [[ -n "$wifi_ip" ]]; then
        echo "wlp3s0          UP    $wifi_ip"
    fi
    if [[ -n "$wired_ip1" ]]; then
        echo "enp2s0f0        UP    $wired_ip1"
    fi
    if [[ -n "$wired_ip2" ]]; then
        echo "enp5s0          UP    $wired_ip2"
    fi
    if [[ -n "$wired_ip3" ]]; then
        echo "enp7s0f3u1      UP    $wired_ip3"
    fi
    exit 0
fi

# Determine which network is active
if [[ -n "$wired_ip1" || -n "$wired_ip2" || -n "$wired_ip3" ]]; then
    echo " "
elif [[ -n "$wifi_ip" ]]; then
    echo "󰖩 "
else
    echo "󰖪 "
fi

