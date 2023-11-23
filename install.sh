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
  sleep 2s

echo "========================================================================="
cd ~
Print_Style "Descargando oh-my-posh" "$GREEN"
sleep 1s
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh

echo "========================================================================="
Print_Style "Asignando permisos de ejecucion" "$YELLOW"
sleep 1s
sudo chmod +x /usr/local/bin/oh-my-posh

echo "======================= CONFIGURANDO TEMAS ================================="
Print_Style "Asignando permisos" "$BLUE"
sleep 1s
sudo mkdir ~/.poshthemes

echo "========================================================================="
Print_Style "Descargando Temas" "$MAGENTA"
sleep 1s
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O themes.zip

echo "========================================================================="
Print_Style "Descomprimiendo..." "$CYAN"
sleep 1s
sudo unzip themes.zip -d ~/.poshthemes

echo "========================================================================="
Print_Style "Asignando permisos" "$WHITE"
sleep 1s
sudo chmod u+rw,g+r ~/.poshthemes/*.json

echo "========================================================================="
Print_Style "Eliminando archivo comprimido" "$BRIGHT"
sleep 1s
sudo rm themes.zip

echo "========================== ACTIVAR ======================================"
Print_Style "Creaar script de inicio para BASH" "$NORMAL"
sleep 1s
sudo oh-my-posh init bash --config .poshthemes/jandedobbeleer.omp.json > .oh-my-post-init.sh

echo "========================================================================="
Print_Style "Enlazar el script en .bashrc" "$BLINK"
sleep 1s
sudo echo "source .oh-my-post-init.sh" >> .bashrc

echo "========================================================================="
Print_Style "Inicializar el prompt" "$RED"
sleep 1s
sudo source .oh-my-post-init.sh