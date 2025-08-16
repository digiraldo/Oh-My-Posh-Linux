#!/bin/bash

# --- CONFIGURACIÓN INICIAL Y MANEJO DE ERORES ---
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
    # ... (El contenido de esta función no cambia y se mantiene igual)
    print_style "=== Iniciando Instalación de Oh My Posh ===" "$GREEN"
    print_style "Descargando binario de Oh My Posh..." "$YELLOW"
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    print_style "Asignando permisos de ejecución..." "$YELLOW"
    sudo chmod +x /usr/local/bin/oh-my-posh
    print_style "Creando directorio para temas (sin sudo)..." "$CYAN"
    mkdir -p ~/.poshthemes
    print_style "Descargando temas..." "$MAGENTA"
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
    # ... (El contenido de esta función no cambia y se mantiene igual)
    print_style "=== Configurando Tema de Oh My Posh en .bashrc ===" "$GREEN"
    echo "Elige el tema que deseas activar:"
    PS3="👉 Por favor, elige una opción: "
    options=( "M365Princess" "Jandedobbeleer" "Larserikfinholt" "Cinnamon" "Markbull" "No cambiar/Cancelar" )
    select opt in "${options[@]}"; do
        case $opt in
            "M365Princess") local config_elegida="~/.poshthemes/M365Princess.omp.json"; break;;
            "Jandedobbeleer") local config_elegida="~/.poshthemes/jandedobbeleer.omp.json"; break;;
            "Larserikfinholt") local config_elegida="~/.poshthemes/larserikfinholt.omp.json"; break;;
            "Cinnamon") local config_elegida="~/.poshthemes/cinnamon.omp.json"; break;;
            "Markbull") local config_elegida="~/.poshthemes/markbull.omp.json"; break;;
            "No cambiar/Cancelar") echo "No se han realizado cambios en .bashrc."; return;;
            *) echo "Opción inválida $REPLY. Intenta de nuevo.";;
        esac
    done
    if [ -n "$config_elegida" ]; then
        print_style "Limpiando configuraciones antiguas de Oh My Posh en .bashrc..." "$YELLOW"
        sed -i '/oh-my-posh --init --shell bash/d' ~/.bashrc
        local nueva_linea="eval \"\$(oh-my-posh --init --shell bash --config $config_elegida)\""
        print_style "Añadiendo nueva configuración al INICIO de .bashrc..." "$YELLOW"
        local temp_file=$(mktemp)
        echo "$nueva_linea" > "$temp_file"
        echo "" >> "$temp_file"
        cat ~/.bashrc >> "$temp_file"
        mv "$temp_file" ~/.bashrc
        print_style "✅ Tema $(basename "$config_elegida") configurado en ~/.bashrc." "$GREEN"
        echo "Para ver los cambios, reinicia tu terminal o ejecuta: source ~/.bashrc"
    fi
}

# 3. CONFIGURACIÓN DE ZONA HORARIA
configure_timezone() {
    # ... (El contenido de esta función no cambia y se mantiene igual)
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
    # ... (El contenido de esta función no cambia y se mantiene igual)
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

# 5. ASEGURAR QUE .bashrc SE CARGUE EN SESIONES SSH (VERSIÓN MEJORADA Y AUTOMÁTICA)
ensure_ssh_login_loads_bashrc() {
    print_style "=== Verificando carga de .bashrc para sesiones SSH (Modo Automático) ===" "$BLUE"
    
    # --- Lógica de Detección Automática del Archivo de Perfil Prioritario ---
    local login_profile_target=""
    if [ -f "$HOME/.bash_profile" ]; then
        login_profile_target="$HOME/.bash_profile"
    elif [ -f "$HOME/.bash_login" ]; then
        login_profile_target="$HOME/.bash_login"
    elif [ -f "$HOME/.profile" ]; then
        login_profile_target="$HOME/.profile"
    else
        # Si no existe ninguno, crearemos .profile como el estándar
        login_profile_target="$HOME/.profile"
    fi
    
    print_style "Se ha detectado '$login_profile_target' como el archivo de perfil prioritario." "$CYAN"

    # --- Verificación y Corrección del Archivo Detectado ---
    # Comprobamos si el archivo ya contiene la línea que carga .bashrc
    if grep -q 'if \[ -f "$HOME/.bashrc" \]; then . "$HOME/.bashrc"; fi' "$login_profile_target" 2>/dev/null; then
        print_style "👍 ¡Excelente! El archivo '$login_profile_target' ya está configurado correctamente." "$GREEN"
    else
        # Si no la contiene, la añadimos al final, preservando el contenido existente.
        print_style "🔥 Atención: El archivo no está cargando .bashrc. Se añadirá la configuración." "$YELLOW"
        
        # Variable que contiene el código a añadir
        read -r -d '' codigo_a_anadir <<'EOF'

# Cargar .bashrc si existe para sesiones de login (añadido por script)
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF
        echo "$codigo_a_anadir" >> "$login_profile_target"
        print_style "✅ Código añadido con éxito a '$login_profile_target'." "$GREEN"
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
    ensure_ssh_login_loads_bashrc # <-- AQUÍ SE EJECUTA LA NUEVA FUNCIÓN MEJORADA
    configure_timezone
    install_timeshift

    print_style "🎉 ¡Proceso de configuración completado! 🎉" "$MAGENTA"
}

# Ejecutar el script
main
