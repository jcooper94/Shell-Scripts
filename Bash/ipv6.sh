#!/bin/bash
ethernet=$(ip addr show eth0)
wifi=$(ip addr show wifi0)

ether_mac_address=$(ip addr show eth0 | grep link/ether | awk '{print $2}')
wifi_mac_address=$(ip addr show wifi0 | grep link/ieee802.11 | awk '{print $2}')

first_mac_ether=$(echo $ether_mac_address | cut -d ':' -f 1-3)
last_mac_ether=$(echo $ether_mac_address | cut -d ':' -f 4-6)

first_mac_wifi=$(echo $wifi_mac_address | cut -d ':' -f 1-3)
last_mac_wifi=$(echo $wifi_mac_address | cut -d ':' -f 4-6)

dashed_oui_ether=$( echo $first_mac_ether | tr : -)
dashed_oui_wifi=$(echo $first_mac_wifi | tr : -)

#if ethernet variable isnt empty -n
if [ -n "$ethernet" ]
then
    echo "Your ethernet mac address is $ether_mac_address"
    echo "The OUI (manufacturer) is $first_mac_ether"
    echo "The NIC (the serial) is $last_mac_ether"
    echo "The manufacturer is $(curl -s https://standards-oui.ieee.org/oui/oui.txt | grep -i $dashed_oui_ether | awk '{print $3 $4 $5 $6}')"
else
    echo "No ethernet"
fi
#if wifi variable isn't empty -n
if [ -n "$wifi" ]
then
    echo "Your wifi mac address is $wifi_mac_address"
    echo "The OUI (manufacturer) is $first_mac_wifi"
    echo "The NIC (the serial) is $last_mac_wifi"
    echo "The manufacturer is $(curl -s https://standards-oui.ieee.org/oui/oui.txt | grep -i $dashed_oui_wifi | awk '{print $3 $4 $5 $6}')"
else
    echo "No wifi."
fi

