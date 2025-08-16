#!/bin/bash

# --- CONFIGURACIÓN INICIAL Y MANEJO DE ERRORES ---
# Detiene el script si un comando falla
set -e

# --- DEFINICIÓN DE COLORES Y FUNCIONES DE ESTILO (una sola vez) ---
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m' # Sin Color

# Función para imprimir texto con estilo
print_style() {
    echo -e "\n${2}${1}${NC}"
}

# --- FUNCIONES MODULARES ---

# 1. INSTALACIÓN DE OH MY POSH
install_oh_my_posh() {
    print_style "=== Iniciando Instalación de Oh My Posh ===" "$GREEN"

    print_style "Descargando binario de Oh My Posh..." "$YELLOW"
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh

    print_style "Asignando permisos de ejecución..." "$YELLOW"
    sudo chmod +x /usr/local/bin/oh-my-posh

    print_style "Creando directorio para temas (sin sudo)..." "$CYAN"
    mkdir -p ~/.poshthemes

    print_style "Descargando temas..." "$MAGENTA"
    # Usamos curl para seguir redirecciones y -o para guardar en un archivo temporal
    curl -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -o ~/themes.zip

    print_style "Descomprimiendo temas en ~/.poshthemes..." "$CYAN"
    unzip -o ~/themes.zip -d ~/.poshthemes
    chmod u+rw ~/.poshthemes/*.json
    rm ~/themes.zip
    
    print_style "Instalando fuentes recomendadas (Nerd Fonts)..." "$GREEN"
    oh-my-posh font install FiraCode
    
    print_style "Migrando glifos de configuración..." "$CYAN"
    oh-my-posh config migrate glyphs --write

    print_style "✅ Oh My Posh instalado correctamente." "$GREEN"
}

# 2. SELECTOR DE TEMAS PARA .bashrc
configure_omp_theme() {
    print_style "=== Configurando Tema de Oh My Posh en .bashrc ===" "$GREEN"

    echo "Elige el tema que deseas activar:"
    PS3="👉 Por favor, elige una opción: "
    
    # Lista de opciones para el menú de selección
    options=(
        "M365Princess"
        "Jandedobbeleer"
        "Larserikfinholt"
        "Cinnamon"
        "Markbull"
        "No cambiar/Cancelar"
    )

    select opt in "${options[@]}"; do
        case $opt in
            "M365Princess")
                local config_elegida="~/.poshthemes/M365Princess.omp.json"
                break
                ;;
            "Jandedobbeleer")
                local config_elegida="~/.poshthemes/jandedobbeleer.omp.json"
                break
                ;;
            "Larserikfinholt")
                local config_elegida="~/.poshthemes/larserikfinholt.omp.json"
                break
                ;;
            "Cinnamon")
                local config_elegida="~/.poshthemes/cinnamon.omp.json"
                break
                ;;
            "Markbull")
                local config_elegida="~/.poshthemes/markbull.omp.json"
                break
                ;;
            "No cambiar/Cancelar")
                echo "No se han realizado cambios en .bashrc."
                return # Salimos de la función por completo
                ;;
            *) 
                echo "Opción inválida $REPLY. Intenta de nuevo."
                ;;
        esac
    done

    # Este bloque solo se ejecuta si se eligió una configuración válida
    if [ -n "$config_elegida" ]; then
        print_style "Limpiando configuraciones antiguas de Oh My Posh en .bashrc..." "$YELLOW"
        # Usamos sed para encontrar y eliminar la línea que inicializa oh-my-posh
        sed -i '/oh-my-posh --init --shell bash/d' ~/.bashrc
        
        # Construimos la nueva línea de configuración
        local nueva_linea="eval \"\$(oh-my-posh --init --shell bash --config $config_elegida)\""
        
        # Añadimos la nueva línea al final del archivo .bashrc
        echo "$nueva_linea" >> ~/.bashrc
        
        print_style "✅ Tema $(basename "$config_elegida") configurado en ~/.bashrc." "$GREEN"
        echo "Para ver los cambios, reinicia tu terminal o ejecuta: source ~/.bashrc"
    fi
}

# 3. CONFIGURACIÓN DE ZONA HORARIA
configure_timezone() {
    print_style "=== Configuración de Zona Horaria ===" "$GREEN"
    sudo timedatectl
    
    read -p "¿Deseas cambiar la zona horaria? [y/N]: " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Ejemplos: America/Mexico_City, America/Bogota, Europe/Madrid"
        read -p "Introduce la nueva zona horaria: " new_tz
        if [ -n "$new_tz" ]; then
            sudo timedatectl set-timezone "$new_tz"
            print_style "Nueva zona horaria establecida:" "$GREEN"
            sudo timedatectl
        else
            echo "No se introdujo ninguna zona horaria. No se realizaron cambios."
        fi
    fi
}

# 4. INSTALACIÓN DE TIMESHIFT
install_timeshift() {
    print_style "=== Instalación de Timeshift ===" "$GREEN"
    read -p "¿Deseas instalar Timeshift para copias de seguridad del sistema? [y/N]: " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo add-apt-repository -y ppa:teejee2008/timeshift
        sudo apt update
        sudo apt install -y timeshift
        print_style "✅ Timeshift instalado correctamente." "$GREEN"
    else
        echo "Instalación de Timeshift omitida."
    fi
}


# --- FUNCIÓN PRINCIPAL QUE EJECUTA EL SCRIPT ---
main() {
    clear
    print_style "=================================================" "$BLUE"
    print_style "    SCRIPT DE INSTALACIÓN Y CONFIGURACIÓN      " "$BLUE"
    print_style "=================================================" "$BLUE"

    # Verificar dependencias básicas
    command -v wget >/dev/null 2>&1 || { echo >&2 "wget no está instalado. Abortando."; exit 1; }
    command -v unzip >/dev/null 2>&1 || { sudo apt update && sudo apt install -y unzip; }

    install_oh_my_posh
    configure_omp_theme
    configure_timezone
    install_timeshift

    print_style "🎉 ¡Proceso de configuración completado! 🎉" "$MAGENTA"
}

# Ejecutar el script
main
