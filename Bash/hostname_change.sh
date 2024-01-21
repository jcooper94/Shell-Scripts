#!/bin/bash
# Check if root user is running the script
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo) to change the hostname."
    exit 1
fi

# Check if a new hostname is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <new_hostname>"
    exit 1
fi

new_hostname=$1

# Update /etc/hostname with the new hostname
echo "$new_hostname" > /etc/hostname

# Update the current hostname
hostnamectl set-hostname "$new_hostname"

echo "Hostname changed to $new_hostname. Reboot WSL2 for the changes to take effect."
