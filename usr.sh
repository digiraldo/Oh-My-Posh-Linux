#!/bin/bash
# 

# Colores del terminal
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Imprime una línea con color usando códigos de terminal
Print_Style() {
  printf "%s\n" "${2}$1${NORMAL}"
}

# Función para leer la entrada del usuario con un mensaje
function read_with_prompt {
  variable_name="$1"
  prompt="$2"
  default="${3-}"
  unset $variable_name
  while [[ ! -n ${!variable_name} ]]; do
    read -p "$prompt: " $variable_name < /dev/tty
    if [ ! -n "`which xargs`" ]; then
      declare -g $variable_name=$(echo "${!variable_name}" | xargs)
    fi
    declare -g $variable_name=$(echo "${!variable_name}" | head -n1 | awk '{print $1;}')
    if [[ -z ${!variable_name} ]] && [[ -n "$default" ]] ; then
      declare -g $variable_name=$default
    fi
    echo -n "$prompt : ${!variable_name} -- aceptar? (y/n)"
    read answer < /dev/tty
    if [ "$answer" == "${answer#[Yy]}" ]; then
      unset $variable_name
    else
      echo "$prompt: ${!variable_name}"
    fi
  done
}

DirName=$(readlink -e ~)
UserName=$(whoami)

Print_Style "$DirName" "$YELLOW"
Print_Style "$UserName" "$MAGENTA"
sleep 1s

# sudo nautilus

# sudo su $UserName

sudo apt-get install sed -y
sudo apt install net-tools -y
sudo apt install openssh-server -y

Print_Style "Buscando todos los usuarios" "$MAGENTA"
sleep 1s
compgen -u

# Print_Style "" "$"
# 
Print_Style "===================================================================" "$REVERSE"
Print_Style "Escriba el nombre de usuario que va a agregar como administrador... Ej: $UserName" "$BRIGHT"
Print_Style "===================================================================" "$REVERSE"
read_with_prompt UserN "Nombre de Usuario"

Print_Style "Agregando $UserN como administrador" "$GREEN"
sleep 1s
#sed -i 'este    ALL=(ALL:ALL) ALL' /etc/sudoers

# sed -i -e 'este    ALL=(ALL:ALL) ALL' /etc/sudoers

# sudo sed -i "/root/ \$usu ALL=\(ALL:ALL\) ALL" /etc/sudoers

# sudo tee -a /etc/sudoers >>> "$usu ALL=(ALL:ALL) ALL"

#sudo sed -i -e '$a $usu ALL=(ALL:ALL) ALL'  /etc/sudoers

# sed -i '/este ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
# sed -i '$a este ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
# sed -n "/este ALL=(ALL) NOPASSWD: ALL/p" /etc/sudoers

Print_Style "===================================================================" "$REVERSE"
sed -i '/este ALL=(ALL:ALL) ALL/d' /etc/sudoers
sed -i '$a este ALL=(ALL:ALL) ALL' /etc/sudoers
sed -n "/este ALL=(ALL:ALL) ALL/p" /etc/sudoers
Print_Style "===================================================================" "$REVERSE"

Print_Style "Configurando usuario $UserN..." "$CYAN"
sleep 1s

sed -i "s:este:$UserN:g" /etc/sudoers

Print_Style "===================================================================" "$REVERSE"
sed -n "/$UserN ALL=(ALL:ALL) ALL/p" /etc/sudoers
Print_Style "===================================================================" "$REVERSE"

# sudo tail /etc/sudoers
# sudo cat /etc/sudoers


# Print_Style "Agregado $usu ALL=(ALL:ALL) ALL" "$BRIGHT"


# sed -n 'ALL/p' /etc/sudoers


Print_Style "===================================================================" "$REVERSE"
sed -n -e '1p' -e '/ALL/p' /etc/sudoers
Print_Style "===================================================================" "$REVERSE"

sleep 1s

sudo rm -rf usr.sh



sudo ufw allow ssh
sleep 2s
#sudo systemctl enable ssh
#sudo systemctl start ssh
sudo service ssh restart

#sudo apt update

# Añadir un espacio al final de una palabra encontrada
# sed -i '/palabra_o_patron_a_buscar/G' nombre_fichero


# sudo systemctl edit php-fpm.service

# sudo systemctl status nginx.service

# sudo service nginx reload
# sudo service php7.4-fpm restart
# https://serverfault.com/questions/1123472/nginx-returning-404-on-new-installation

# /var/run/php/php7.2-fpm.sock

# https://serverfault.com/questions/317231/when-accessing-php-files-nginx-throws-an-404-error

# https://stackoverflow.com/questions/70297812/nginx-php-404-not-found-when-redirecting-away-from-main-website

# https://stackoverflow.com/questions/51254473/php-with-nginx-403-forbidden

# sudo chmod 755 /var/www