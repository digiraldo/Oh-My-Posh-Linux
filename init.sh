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

# Print_Style "" "$"
# 
## Cómo instalar Linux, Nginx, MySQL y PHP (pila LEMP)
Print_Style "========================================" "$REVERSE"
Print_Style "Paso 1: Instalación el servidor web Nginx" "$BLINK"
Print_Style "========================================" "$REVERSE"
sleep 1s
# Instalar el servidor web Nginx
Print_Style "Instalando servidor web Nginx" "$GREEN"
sudo apt update && sudo apt upgrade

# Importa la clave de firma de Nginx
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
| sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Añade el repositorio de la versión estable de Nginx
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg arch=amd64] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
| sudo tee /etc/apt/sources.list.d/nginx.list

#Actualiza los repositorios del sistema
sudo apt update

# Instala Nginx
sudo apt install nginx -y

# Verifica la instalación
nginx -v


Print_Style "verificando perfiles UFW disponibles" "$"
sudo ufw app list

Print_Style "habilitando el perfil más restrictivo" "$CYAN"
sudo ufw allow 'Nginx HTTP'
Print_Style "Mostrando tráfico de HTTP" "$YELLOW"
sudo ufw status

Print_Style "Dirección IP accesible o pública" "$RED"
dirección IP accesible

rint_Style "========================================" "$REVERSE"
# Print_Style "Paso 2: Instalacion de MySQL" "$BLINK"
Print_Style "========================================" "$REVERSE"
# sleep 1s

Print_Style "========================================" "$REVERSE"
Print_Style "Paso 3: Instalacion de PHP" "$BLINK"
Print_Style "========================================" "$REVERSE"
sleep 1s

Print_Style "Instalando paquetes php-fpm y php-mysql" "$GREEN"
sudo apt update && sudo apt install php-fpm -y
#sudo apt install php-fpm php-mysql

sudo systemctl status nginx mysql

Print_Style "Configurando Nginx para utilizar el procesador PHP" "$GREEN"


cd ~


# Descargar cloud.sh desde el repositorio
echo "Tomando misitio.conf del repositorio..."
curl -H "Accept-Encoding: identity" -L -o cloud.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server/main/misitio.conf
chmod +x misitio.conf
#sudo sed -i "s:dirname:$DirName:g" cloud.sh
#sudo sed -i "s:servername:$ServerName:g" cloud.sh



# https://howtoforge.es/como-instalar-nginx-con-php-y-mysql-lemp-stack-en-ubuntu-22-04/