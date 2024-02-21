#PLANS
#arm64 like raspberry pi
#Persistant Live USB
#for devices like firestick
#Termux installation

#TODO
#create a package with answer file and bash startup script
#package that into a iso
#https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso

# automount and setup harddrives and pass to docker containers
# allow users to specify their VPN provider
# network_mode: "service:gluetun"
# added for prowlarr and qbittorent containers (these containers use the gluten container network that is through the vpn service)

#OPTIONS
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
apk update
apk upgrade
apk add curl
#allow root ssh login
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
service sshd restart
#remove doas password(maybe silly to do so i know)
echo "permit nopass root" | tee -a /etc/doas.conf
#change /etc/os-release
echo 'NAME="Pirate Box"' | tee /etc/os-release >/dev/null
echo 'ID=piratebox' | tee -a /etc/os-release >/dev/null
echo 'VERSION_ID=3.19.1' | tee -a /etc/os-release >/dev/null
echo 'PRETTY_NAME="Pirate Box"' | tee -a /etc/os-release >/dev/null
echo 'HOME_URL="Your Mom'"'"'s House"' | tee -a /etc/os-release >/dev/null
#change /etc/motd
echo "Avast Ye Land Lubber Welcome Aboard to Ye Ole Pirate Box! Let me pour ye some rum." | tee /etc/motd >/dev/null
#change /etc/issue
echo Ahoy Matey!  Go on login and let ole captain piratebox tell ye a tale! | tee /etc/issue >/dev/null

#INSTALL SCREENFETCH
cd /usr/local/bin/
wget -O screenfetch https://raw.githubusercontent.com/KittyKatt/screenFetch/master/screenfetch-dev
chmod +x screenfetch
#in future once everything works add pirate ascii art to source code

#INSTALL NEOFETCH
wget https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
chmod +x neofetch
#in future once everything works add pirate ascii art to source code

#INSTALL DOCKER AND DOCKER COMPOSE
apk add docker
rc-update add docker boot
service docker start
adduser root docker
wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64
chmod +x /usr/local/bin/docker-compose
echo "Docker installed!"