#!/bin/bash
ether_mac_address=$(ip addr show eth0 | grep link/ether | awk '{print $2}')
wifi_mac_address=$(ip addr show wifi0 | grep link | awk '{print $2}')
ethernet=$(ip addr | grep eth)
wifi=$(ip addr | grep wifi0)
#if ethernet exists
if [ -n :"$ethernet" ]
then
    echo "Your ethernet mac address is $ether_mac_address"
fi
#if wifi exists
if [ -n "$wifi" ]
then
    echo "Your wifi mac address is $wifi_mac"
fi