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

# https://medium.com/linux-tips-101/bash-script-con-salida-en-colores-82bab9263998

function logWarn() {
	START='\033[01;33m'
	END='\033[00;00m'
	MESSAGE=${@:-""}
	echo -e "${START}${MESSAGE}${END}"
}

function logInfo() {
	START='\033[01;32m'
	END='\033[00;00m'
	MESSAGE=${@:-""}
	echo -e "${START}${MESSAGE}${END}"
}

function logError() {
	START='\033[01;31m'
	END='\033[00;00m'
	MESSAGE=${@:-""}
	echo -e "${START}${MESSAGE}${END}"
}

function log() {
        MESSAGE=${@:-""}
        echo -e "${MESSAGE}"
}

log "Mensaje con Texto Normal"
logInfo "Mensaje con Texto Informativo (Verde)"
logWarn "Mensaje con Texto para Alarma (Amarillo)"
logError "Mensaje con Texto para Error (Rojo)"


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
sudo apt update
sudo apt upgrade -y

sudo apt-get install build-essential procps curl file git -y
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bash_profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew doctor
# sudo apt install curl
Print_Style "Descargando oh-my-posh" "$GREEN"
sleep 2s

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

sudo apt-get install build-essential procps curl file git -y

brew install jandedobbeleer/oh-my-posh/oh-my-posh

brew update && brew upgrade oh-my-posh

# sudo curl -s https://ohmyposh.dev/install.sh | bash -s

# sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh

brew tap homebrew/cask-fonts                     # You only need to do this once!
brew search nerd-font                            # Search for font packages

# EXAMPLE: Install the NF version of Fira Code
brew install --cask font-fira-code-nerd-font

# INSTALLL MORE

export TERM=x-term-256color
export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$PATH

# Plugins
eval "$(oh-my-posh init zsh --config /mnt/c/Users/Maverick/AppData/Local/Programs/oh-my-posh/themes/jandedobbeleer.omp.json)"


mkdir .zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git .zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .zsh/zsh-syntax-highlightings


sudo snap install jump
sudo apt install ruby-full
sudo gem install colorls





echo "========================================================================="
Print_Style "Asignando permisos de ejecucion" "$YELLOW"
sleep 2s
cd ~
# sudo chmod +x /usr/local/bin/oh-my-posh
#sudo chmod +x $DirName/bin/oh-my-posh


echo "========================================================================="
echo "======================= CONFIGURANDO TEMAS ================================="
echo "========================================================================="
sleep 2s
Print_Style "Asignando permisos" "$BLUE"
sleep 2s
cd ~
# sudo mkdir ~/.poshthemes
Print_Style "seleccionamos fuente FiraCode o Meslo" "$REVERSE"
# sudo oh-my-posh font install

echo "========================================================================="
Print_Style "Descargando Temas" "$MAGENTA"
sleep 1s
cd ~
# sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O themes.zip

echo "========================================================================="
Print_Style "Descomprimiendo" "$CYAN"
sleep 2s
# sudo apt install unzip
cd ~
# sudo unzip themes.zip -d ~/.poshthemes

echo "========================================================================="
Print_Style "Asignando permisos" "$RED"
sleep 2s
cd ~
# sudo chmod u+rw,g+r ~/.poshthemes/*.json

echo "========================================================================="
Print_Style "Eliminando archivo comprimido" "$GREEN"
sleep 2s
# sudo rm -rf themes.zip

echo "========================================================================="
Print_Style "Migrar ubicacion de fuentes" "$CYAN"
sleep 2s
# sudo oh-my-posh config migrate glyphs --write

echo "========================================================================="
echo "========================== ACTIVAR ======================================"
echo "========================================================================="
sleep 2s
Print_Style "Creaar script de inicio para BASH" "$YELLOW"
sleep 2s
cd ~
# sudo oh-my-posh init bash --config .poshthemes/jandedobbeleer.omp.json > .oh-my-post-init.sh

echo "========================================================================="
Print_Style "Enlazar el script en .bashrc" "$BLUE"
sleep 2s
cd ~
# sudo echo "source .oh-my-post-init.sh" >> .bashrc


echo "========================================================================="
Print_Style "Inicializar el prompt con:" "$MAGENTA"
sleep 2s
# source .oh-my-post-init.sh
sleep 4s
# source .bashrc
Print_Style "source .bashrc" "$REVERSE"
Print_Style "source .oh-my-post-init.sh" "$REVERSE"


brew update && brew upgrade oh-my-posh
eval "$(oh-my-posh init bash --config ~/jandedobbeleer.omp.json)"
sudo rm insta.sh