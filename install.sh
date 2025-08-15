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
sleep 2s
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh

echo "========================================================================="
Print_Style "Asignando permisos de ejecucion" "$YELLOW"
sleep 2s
cd ~
sudo chmod +x /usr/local/bin/oh-my-posh
#sudo chmod +x $DirName/bin/oh-my-posh


echo "========================================================================="
echo "======================= CONFIGURANDO TEMAS ================================="
echo "========================================================================="
sleep 2s
Print_Style "Asignando permisos" "$BLUE"
sleep 2s
cd ~
sudo mkdir ~/.poshthemes
Print_Style "seleccionamos fuente FiraCode o Meslo" "$REVERSE"
sudo oh-my-posh font install

echo "========================================================================="
Print_Style "Descargando Temas" "$MAGENTA"
sleep 1s
cd ~
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O themes.zip

echo "========================================================================="
Print_Style "Descomprimiendo" "$CYAN"
sleep 2s
sudo apt install unzip
cd ~
sudo unzip themes.zip -d ~/.poshthemes

echo "========================================================================="
Print_Style "Asignando permisos" "$RED"
sleep 2s
cd ~
sudo chmod u+rw,g+r ~/.poshthemes/*.json

echo "========================================================================="
Print_Style "Eliminando archivo comprimido" "$GREEN"
sleep 2s
sudo rm -rf themes.zip

echo "========================================================================="
Print_Style "Migrar ubicacion de fuentes" "$CYAN"
sleep 2s
sudo oh-my-posh config migrate glyphs --write

echo "========================================================================="
echo "========================== ACTIVAR ======================================"
echo "========================================================================="
sleep 2s
Print_Style "Creaar script de inicio para BASH" "$YELLOW"
sleep 2s
cd ~
# sudo oh-my-posh init bash --config .poshthemes/jandedobbeleer.omp.json > .oh-my-post-init.sh

echo "========================================================================="
# Print_Style "Enlazar el script en .bashrc" "$BLUE"
# sleep 2s
# cd ~
# sudo echo "source .oh-my-post-init.sh" >> .bashrc


echo "========================================================================="
# Print_Style "Inicializar el prompt con:" "$MAGENTA"
# sleep 2s
# source .oh-my-post-init.sh
# sleep 4s
# source .bashrc
# Print_Style "source .bashrc" "$REVERSE"
# Print_Style "source .oh-my-post-init.sh" "$REVERSE"

sudo sed -i '$a eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/jandedobbeleer.omp.json)"' .bashrc

#  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- 0. AÑADIR .bashrc PARA QUE INICIE AUTOMATICAMENTE CUANDO INICIAMOS EN SSH ---
# --- 0. AÑADIR .bashrc PARA QUE INICIE AUTOMATICAMENTE CUANDO INICIAMOS EN SSH ---

# Limpiar la pantalla para una visualización clara
#  clear

# --- 1. DEFINICIÓN DE VARIABLES ---

# Variable que contiene el código a añadir. Usamos un "here document" para manejar múltiples líneas fácilmente.
read -r -d '' codigo_a_anadir <<'EOF'

# Cargar .bashrc si existe para sesiones de login
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF

# Variables de estado (0 = no encontrado, 1 = encontrado)
profile_has_code=0
bash_profile_has_code=0
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Función para imprimir con estilo
Print_Style() {
    echo -e "${2}${1}${NC}"
}

# --- 2. FASE DE VERIFICACIÓN ---

echo "========================================================================="
Print_Style "Iniciando auditoría de archivos de perfil de Bash..." "$BLUE"
echo "========================================================================="
sleep 1

# Verificar ~/.profile
if [ -f ~/.profile ] && grep -q '. "$HOME/.bashrc"' ~/.profile; then
    profile_has_code=1
    echo "✅ Encontrado: El código ya existe en ~/.profile."
else
    echo "❌ No encontrado: El código falta en ~/.profile."
fi

# Verificar ~/.bash_profile
if [ -f ~/.bash_profile ] && grep -q '. "$HOME/.bashrc"' ~/.bash_profile; then
    bash_profile_has_code=1
    echo "✅ Encontrado: El código ya existe en ~/.bash_profile."
else
    echo "❌ No encontrado: El código falta en ~/.bash_profile."
fi
echo "========================================================================="
echo ""


# --- 3. FASE DE DECISIÓN Y ACCIÓN ---

# Escenario 1: Ambos archivos ya están configurados correctamente.
if [ $profile_has_code -eq 1 ] && [ $bash_profile_has_code -eq 1 ]; then
    Print_Style "👍 ¡Excelente! Ambos archivos están configurados correctamente." "$BLUE"
    exit 0
fi

# Escenario 2: El código falta en AMBOS archivos. Se agrega automáticamente.
if [ $profile_has_code -eq 0 ] && [ $bash_profile_has_code -eq 0 ]; then
    Print_Style "🔥 Atención: El código no se encontró en ninguno de los dos archivos." "$BLUE"
    echo "Agregando la configuración a ~/.profile y ~/.bash_profile automáticamente..."
    sleep 1
    echo "$codigo_a_anadir" >> ~/.profile
    echo "✅ Código añadido con éxito a ~/.profile"
    echo "$codigo_a_anadir" >> ~/.bash_profile
    echo "✅ Código añadido con éxito a ~/.bash_profile"
    exit 0
fi

# Escenario 3: El código falta en solo UNO de los archivos. Se ofrece un menú.
Print_Style "👉 Se ha detectado una configuración incompleta. Elige una acción:" "$BLUE"
PS3="Por favor, elige una opción: "

# Crear las opciones del menú dinámicamente
options=()
if [ $profile_has_code -eq 0 ]; then
    options+=("Agregar código a ~/.profile")
fi
if [ $bash_profile_has_code -eq 0 ]; then
    options+=("Agregar código a ~/.bash_profile")
fi
options+=("Salir sin hacer nada")

select opt in "${options[@]}"; do
    case $opt in
        "Agregar código a ~/.profile")
            echo "$codigo_a_anadir" >> ~/.profile
            Print_Style "✅ ¡Hecho! El código ha sido añadido a ~/.profile." "$BLUE"
            break
            ;;
        "Agregar código a ~/.bash_profile")
            echo "$codigo_a_anadir" >> ~/.bash_profile
            Print_Style "✅ ¡Hecho! El código ha sido añadido a ~/.bash_profile." "$BLUE"
            break
            ;;
        "Salir sin hacer nada")
            echo "No se han realizado cambios."
            break
            ;;
        *) 
            echo "Opción inválida: $REPLY. Por favor, intenta de nuevo."
            ;;
    esac
done

echo ""
echo "========================================================================="
# --- 0. AÑADIR .bashrc PARA QUE INICIE AUTOMATICAMENTE CUANDO INICIAMOS EN SSH ---
# --- 0. AÑADIR .bashrc PARA QUE INICIE AUTOMATICAMENTE CUANDO INICIAMOS EN SSH ---


# --- Ejecución Principal ---

# 1. Llama a la función que muestra la animación
animacion_inicio

# 2. Después de los 5 segundos, ejecuta el comando de Oh My Posh
eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/jandedobbeleer.omp.json)"




# eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/atomic.omp.json)"
eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/jandedobbeleer.omp.json)"

echo "========================================================================="
echo "========================================================================="
sudo timedatectl
echo "========================================================================="
read -r -p "Sincronizar Zona Horaria? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo "========================================================================="
Print_Style "Configurando Zona Horaria" "$MAGENTA"
echo "========================================================================="
echo "Voiendo Zona horaria actual del sistema"
sudo timedatectl
echo "========================================================================="
sleep 5s
Print_Style "Configurando Sincronizacion de Zona Horaria" "$BLUE"
sleep 2s
sudo apt install systemd-timesyncd
Print_Style "Sincronizando Zona Horaria desde el Sistema" "$BLUE"
sudo timedatectl set-ntp true
    sleep 2s
else
    Print_Style "Zona Horaria Actual: $CYAN $TZ" "$NORMAL"
fi



echo "========================================================================="
echo "========================================================================="
sudo timedatectl
echo "========================================================================="
TZ=$(sudo cat /etc/timezone)
Print_Style "Zona Horaria Actual: $CYAN $TZ" "$GREEN"
echo "========================================================================="

read -r -p "Cambiar Zona Horaria? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Digitar Zona Horaria
    echo "========================================================================="
    Print_Style "Introduzca la Zona Horaria: " "$MAGENTA"
    Print_Style "Ejemplos:" "$YELLOW"
    Print_Style "America/Mexico_City" "$CYAN"
    Print_Style "America/Bogota" "$CYAN"
    read_with_prompt NewTZ "Introduzca Zona Horaria"
    echo "========================================================================="
    sleep 3s
    sudo timedatectl set-timezone $NewTZ
    # sudo timedatectl set-timezone America/Mexico_City
    TZN=$(sudo cat /etc/timezone)
    sleep 2s
    # ln -sfn /usr/share/zoneinfo/$NewTZ /etc/localtime
    Print_Style "Nueva Zona Horaria: $CYAN $TZN" "$NORMAL"
    sleep 2s
else
    Print_Style "Zona Horaria Actual: $CYAN $TZ" "$NORMAL"
fi

SistemaLin=$(lsb_release -i)
var1="$SistemaLin"
RecorLin=${var1#Distributor ID\:}
LinuxSistemInstall=$(echo "$RecorLin" | tr -d '[[:space:]]' | awk '{print tolower($0)}')

# Hacer instantaneas en linux
# https://dev.to/rahedmir/how-to-use-timeshift-from-command-line-in-linux-1l9b
sudo add-apt-repository -y ppa:teejee2008/timeshift
sudo apt update
sudo apt install timeshift -y
