#!/bin/bash
# 
# Instrucciones: https://github.com/LomotHo/minecraft-bedrock
# Instrucciones en Español: https://gorobeta.blogspot.com
# Repositorio de GitHub: https://github.com/digiraldo/Minecraft-BE-Server-Panel-Admin-Web
# Crear Usuario https://noviello.it/es/como-crear-un-usuario-de-sudo-en-linux-debian/

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

  Print_Style "Fuente de Color BLACK" "$BLACK"
  Print_Style "Fuente de Color RED" "$RED"
  Print_Style "Fuente de Color GREEN" "$GREEN"
  Print_Style "Fuente de Color YELLOW" "$YELLOW"
  Print_Style "Fuente de Color LIME_YELLOW" "$LIME_YELLOW"  
  Print_Style "Fuente de Color BLUE" "$BLUE"
  Print_Style "Fuente de Color MAGENTA" "$MAGENTA"
  Print_Style "Fuente de Color CYAN" "$CYAN"
  Print_Style "Fuente de Color WHITE" "$WHITE"
  Print_Style "Fuente de Color BRIGHT" "$BRIGHT"
  Print_Style "Fuente de Color NORMAL" "$NORMAL"  
  Print_Style "Fuente de Color BLINK" "$BLINK"
  Print_Style "Fuente de Color REVERSE" "$REVERSE"
  Print_Style "Fuente de Color UNDERLINE" "$UNDERLINE"
#  sleep 6s

echo "========================================================================="

cd ~

sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

sudo unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
sudo chmod u+rw ~/.poshthemes/*.json
sudo rm ~/.poshthemes/themes.zip

echo "========================================================================="

sudo mkdir ~/.poshthemes
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
sudo unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
sudo chmod u+rw ~/.poshthemes/*.json
sudo rm ~/.poshthemes/themes.zip

cd ~
sudo mkdir .fonts
sudo mkdir Descargas
sudo unzip ~/Descargas/Meslo.zip -d ~/.fonts/Meslo
sudo fc-cache -fv

echo "========================================================================="

FILE=~/.bashrc


if [ -f $FILE ]
then
   echo "El fichero $FILE existe"
     cd ~
     encontrar=`cat .bashrc | grep eval | wc -l`
      
     if [ $encontrar -gt 0 ];then
         echo "Encontrado"
     else
         echo "NO encontrado"
     fi
#   sudo sed -i 's/^eval .*$/el contenido de la línea ha sido reemplazado/' ~/.bashrc
else
   echo "El fichero $FILE no existe"
fi