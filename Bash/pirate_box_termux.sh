#!/bin/bash
pkg update && pkg upgrade -y
pkg install openssh
#start the openssh daemon
sshd
#tells user the ip address to ssh to
ssh_ip=$(ifconfig | grep inet | grep -v "127.0.0.1" | awk '{print $2}')
ssh_hostname=$(whoami)
RED='\033[0;31m'
echo -e "${RED}on remote device type \n ssh $ssh_hostname@$ssh_ip -p8022${RED}"
# Install QEMU
echo "Installing QEMU..."
pkg install -y gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C8CAB6595FDFF622
echo "deb https://grimler.se/termux extra main" > $PREFIX/etc/apt/sources.list.d/grimler.list
pkg update
pkg install -y qemu-system-aarch64

# Download Debian 12 Installer Files
echo "Downloading Debian 12 installer files..."
wget http://ftp.debian.org/debian/dists/debian12/main/installer-arm64/current/images/netboot/debian-installer/arm64/initrd.gz
wget http://ftp.debian.org/debian/dists/debian12/main/installer-arm64/current/images/netboot/debian-installer/arm64/linux

# Download preseed.cfg
echo "Downloading preseed configuration file..."
wget https://raw.githubusercontent.com/jcooper94/Playground/main/Linux/preseed.cfg

# Create a Disk Image
echo "Creating disk image..."
qemu-img create -f qcow2 disk.qcow2 8G

# Invoke the Installer
echo "Invoking installer with preseed configuration file..."
qemu-system-aarch64 -smp 2 -cpu cortex-a57 -m 1G \
    -initrd initrd.gz \
    -kernel linux -append "root=/dev/ram console=ttyAMA0 auto=true url=preseed.cfg" \
    -drive file=disk.qcow2,format=qcow2 \
    -device e1000,netdev=net0 \
    -netdev user,hostfwd=tcp:127.0.0.1:2222-:22

# Extract the Kernel
echo "Extracting kernel..."
pkg install -y nbd-client
modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 disk.qcow2
mkdir mnt
mount /dev/nbd0p1 mnt
cp mnt/initrd.img-* mnt/vmlinuz-* .
sync
umount /dev/nbd0p1
nbd-client -d /dev/nbd0

# Engage
echo "Running emulated system..."
qemu-system-aarch64 -smp 2 -cpu cortex-a57 -m 1G \
    -initrd initrd.img-* \
    -kernel vmlinuz-* \
    -append "root=/dev/sda2 console=ttyAMA0" \
    -drive file=disk.qcow2,format=qcow2 \
    -device e1000,netdev=net0 \
    -netdev user,hostfwd=tcp:127.0.0.1:2222-:22