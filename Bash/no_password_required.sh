#!/bin/bash

# Warn user about best practice
echo "This is NOT best practice; if you want to disable sudo, it's best to do it per application."

# Tell user about backup file
echo "Backing up /etc/sudoers to /home/$(whoami)/sudoers.bak; if you have problems, you can restore from there."

# Make backup
sudo cp /etc/sudoers "/home/$(whoami)/sudoers.bak"

# Add sudoers configuration line
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

echo "Done!"
