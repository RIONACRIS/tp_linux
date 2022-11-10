#!/bin/bash
GN='\033[0;32m'
RD='\033[0;31m'
YO='\033[0;33m'
NC='\033[0m'

clear

if [ "$(whoami)" != 'root' ]; then
printf "${RD} Vous devez vous connecter en root ${NC}\n"
exit 1;
fi


function webserver_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
| ** Veuillez choisir la fonctionnalité que vous voulez éffectuer ** |
|                                                                    |
|    1.) Installation et Configuration du server SSH avec clés        |
|    2.) Installation et configuration du server Web + WAMPServer    |
|    3.) Configurer pour écouter sur toutes ses interfaces           |
|    4.) Installer et Configurer proprement iptables		     |
|                                                                    |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

}

webserver_selection

echo "Selectionnez les serveurs que vous voulez installer : "
read -e -p choice

if [ "$choice" == "1" ]; then

    echo -e "Installation et Configuration du server SSH avec clés..."
    apt -y install openssh-server
    steep 1
    systemctl enable --now ssh.service
    steep 1
    ssh-keygen
    steep 1
    sed -i -e '
    s/PermitRootLogin yes/PermitRootLogin no/g' -e '
    s/PasswordAuthentication yes/PasswordAuthentication no/g' -e '
    s/#PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
    steep 1
    systemctl restart ssh
    steep 1
    clear && webserver_selection
fi

if [ "$choice" == "2" ]; then

    echo -e "Installation d'Apache ..."
    apt-get update
    steep 1
    apt-get install -y apache2
    steep 1
    systemctl enable apache2
    a2enmod rewrite
    a2enmod deflate
    a2enmod headers
    a2enmod ssl
    systemctl restart apache2
    sleep 3
    
    
    echo -e "Installation de PHP..."
    apt-get install -y php
    apt-get install -y php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath
    sleep 3
    
    
    echo -e "Installation de Mariadb..."
    apt-get install -y mariadb-server
    mariadb-secure-installation
    systemctl restart mariadb
    clear && webserver_selection
fi
