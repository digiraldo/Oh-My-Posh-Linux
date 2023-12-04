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
Print_Style "Buscando todos los usuarios" "$MAGENTA"
sleep 1s
compgen -u
# Print_Style "" "$"
# 
Print_Style "===================================================================" "$REVERSE"
Print_Style "Escriba el nombre de usuario que va a agregar como administrador..." "$BRIGHT"
Print_Style "===================================================================" "$REVERSE"
read_with_prompt usu "Nombre de Usuario"

Print_Style "Agregando $usu como administrador" "$GREEN"
sleep 1s
sudo sed -i 'este    ALL=(ALL:ALL) ALL' /etc/sudoers

# sudo sed -i "/root/ \$usu ALL=\(ALL:ALL\) ALL" /etc/sudoers

# sudo tee -a /etc/sudoers >>> "$usu ALL=(ALL:ALL) ALL"

sudo sed -i "s:este:$usu:g" /etc/sudoers
sudo sed -i "s:este:$usu:g" ~usr.sh

#sudo sed -i -e '$a $usu ALL=(ALL:ALL) ALL'  /etc/sudoers
# sed -i '/$usu ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
# sed -i '$a $usu ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
# sed -n "/$usu ALL=(ALL) NOPASSWD: ALL/p" /etc/sudoers



sudo tail /etc/sudoers

Print_Style "===================================================================" "$REVERSE"
Print_Style "Agregado \este ALL=\(ALL:ALL\) ALL" "$BRIGHT"
Print_Style "===================================================================" "$REVERSE"

sleep 1s

sudo rm -rf usr.sh

#sudo apt update


