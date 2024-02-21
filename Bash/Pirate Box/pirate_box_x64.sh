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

# Create a temporary file with the desired content
cat << 'EOF' > /tmp/profile_tmp
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PAGER=less
umask 022
# Set up PS1 for bash and busybox ash
if [ -n "$BASH_VERSION" ] || [ -n "$BB_ASH_VERSION" ]; then
    PS1='\[\033[1;31m\][\[\033[1;33m\]\u\[\033[1;32m\]@\h \[\033[1;34m\]\w\[\033[1;31m\]]\$\[\033[0m\] '
# Set up PS1 for zsh
elif [ -n "$ZSH_VERSION" ]; then
    PS1='%m:%~%# '
# Fallback default PS1
else
    PS1='\[\033[1;31m\][\[\033[1;33m\]\u\[\033[1;32m\]@\h \[\033[1;34m\]\w\[\033[1;31m\]]\$\[\033[0m\] '
    [ "$(id -u)" -eq 0 ] && PS1="${PS1}# " || PS1="${PS1}\$ "
fi

for script in /etc/profile.d/*.sh; do
    if [ -r "$script" ]; then
        . "$script"
    fi
done
unset script
EOF
# Replace /etc/profile with the content of the temporary file
mv /tmp/profile_tmp /etc/profile

#INSTALL NEOFETCH
wget https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
chmod +x neofetch

#create neofetch ascii logo
cat << EOF > /etc/ascii_art.txt
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠤⠴⠶⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣾⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠂⠉⡇⠀⠀⠀⢰⣿⣿⣿⣿⣧⠀⠀⢀⣄⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢠⣶⣶⣷⠀⠀⠀⠸⠟⠁⠀⡇⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⠟⢹⣋⣀⡀⢀⣤⣶⣿⣿⣿⣿⣿⡿⠛⣠⣼⣿⡟⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣴⣾⣿⣿⣿⣿⢁⣾⣿⣿⣿⣿⣿⣿⡿⢁⣾⣿⣿⣿⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⠿⠇⠀⠀⠀⠀
⠀⠀⠀⠳⣤⣙⠟⠛⢻⠿⣿⠸⣿⣿⣿⣿⣿⣿⣿⣇⠘⠉⠀⢸⠀⢀⣠⠀⠀⠀
⠀⠀⠀⠀⠈⠻⣷⣦⣼⠀⠀⠀⢻⣿⣿⠿⢿⡿⠿⣿⡄⠀⠀⣼⣷⣿⣿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣶⣄⡈⠉⠀⠀⢸⡇⠀⠀⠉⠂⠀⣿⣿⣿⣧⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣷⣤⣀⣸⣧⣠⣤⣴⣶⣾⣿⣿⣿⡿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
EOF

#create alias for neofetch
echo "alias neofetch='neofetch --source /etc/ascii_art.txt'" >> ~/.ashrc 

#INSTALL DOCKER AND DOCKER COMPOSE
apk add docker
rc-update add docker boot
service docker start
adduser root docker
wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64
chmod +x /usr/local/bin/docker-compose
echo "Docker installed!"