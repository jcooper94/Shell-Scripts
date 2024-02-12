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

#convert EUI-48 to EUI-64
#split the MAC, two 3 byte (24-bit) halves
#put FFFE in the middle
# BIA (burned in address) to locally administered address
#invert the seventh bit

# Define flip arrays
flipArray1=(0 1 4 5 8 9 c d)
flipArray2=(2 3 6 7 a b e f)
# Ethernet
# Get the second character out of first half of MAC address
flipped_bit_ether=$(echo $first_mac_ether | cut -d':' -f1 | cut -c2)

# Check if flipped_bit_ether is in flipArray1 or flipArray2
for (( i=0; i<${#flipArray1[@]}; i++ )); do
    if [[ ${flipArray1[i]} == "$flipped_bit_ether" ]]; then
        # Replace with the corresponding character from flipArray2
        flipped_bit_ether=${flipArray2[i]}
        break
    elif [[ ${flipArray2[i]} == "$flipped_bit_ether" ]]; then
        # Replace with the corresponding character from flipArray1
        flipped_bit_ether=${flipArray1[i]}
        break
    fi
done

# Wi-Fi
# Get the second character out of first half of MAC address
flipped_bit_wifi=$(echo $first_mac_wifi | cut -d':' -f1 | cut -c2)

# Check if flipped_bit_wifi is in flipArray1 or flipArray2
for (( i=0; i<${#flipArray1[@]}; i++ )); do
    if [[ ${flipArray1[i]} == "$flipped_bit_wifi" ]]; then
        # Replace with the corresponding character from flipArray2
        flipped_bit_wifi=${flipArray2[i]}
        break
    elif [[ ${flipArray2[i]} == "$flipped_bit_wifi" ]]; then
        # Replace with the corresponding character from flipArray1
        flipped_bit_wifi=${flipArray1[i]}
        break
    fi
done

echo "Flipped bit for Ethernet: $flipped_bit_ether"
echo "Flipped bit for Wi-Fi: $flipped_bit_wifi"

modified_mac_ether="${first_mac_ether:0:1}${flipped_bit_ether}${first_mac_ether:2}"
echo "$modified_mac_ether"

modified_mac_wifi="${first_mac_wifi:0:1}${flipped_bit_wifi}${first_mac_wifi:2}"
echo "$modified_mac_wifi"

#ethernet
eth_inet_pre=$(ip addr show eth0 | awk '/inet6 .* scope global dynamic/ {print $2; exit}' | cut -d'/' -f1 | cut -d: -f1-4)
echo "The ipv6 network subnet address is $eth_inet_pre."
# #wifi
wifi_inet_pre=$(ip addr show eth0 | awk '/inet6 .* scope global dynamic/ {print $2; exit}' | cut -d'/' -f1 | cut -d: -f1-4)
echo "The ipv6 network subnet address is $wifi_inet_pre."

concat_eth="${eth_inet_pre}${modified_mac_ether}fffe${last_mac_ether}"
echo "$concat_eth"

concat_wifi="${wifi_inet_pre}${modified_mac_wifi}fffe${last_mac_wifi}"
echo "$concat_eth"