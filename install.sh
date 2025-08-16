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
        
        # --- BLOQUE MODIFICADO PARA AÑADIR AL INICIO ---
        print_style "Añadiendo nueva configuración al INICIO de .bashrc..." "$YELLOW"
        local temp_file=$(mktemp)
        # 1. Escribir la nueva línea de Oh My Posh en el archivo temporal.
        echo "$nueva_linea" > "$temp_file"
        # 2. Añadir un salto de línea para separar.
        echo "" >> "$temp_file"
        # 3. Añadir el contenido del .bashrc original (ya limpio) al archivo temporal.
        cat ~/.bashrc >> "$temp_file"
        # 4. Reemplazar el .bashrc original con el nuevo archivo temporal.
        mv "$temp_file" ~/.bashrc
        # --- FIN DEL BLOQUE MODIFICADO ---
        
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

# 5. ASEGURAR QUE .bashrc SE CARGUE EN SESIONES SSH
ensure_ssh_login_loads_bashrc() {
    print_style "=== Verificando carga de .bashrc para sesiones SSH ===" "$BLUE"
    
    # Variable que contiene el código a añadir
    read -r -d '' codigo_a_anadir <<'EOF'

# Cargar .bashrc si existe para sesiones de login
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF
    
    # Variables de estado
    local profile_has_code=0
    local bash_profile_has_code=0

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

    # --- FASE DE DECISIÓN Y ACCIÓN ---

    # Escenario 1: Ambos archivos ya están configurados
    if [ $profile_has_code -eq 1 ] && [ $bash_profile_has_code -eq 1 ]; then
        print_style "👍 ¡Excelente! La configuración para SSH ya es correcta." "$GREEN"
        return
    fi

    # Escenario 2: Falta en ambos archivos
    if [ $profile_has_code -eq 0 ] && [ $bash_profile_has_code -eq 0 ]; then
        print_style "🔥 Atención: El código no se encontró en ningún archivo de perfil." "$YELLOW"
        echo "Agregando la configuración a ~/.profile automáticamente..."
        echo "$codigo_a_anadir" >> ~/.profile
        echo "✅ Código añadido con éxito a ~/.profile"
        return
    fi

    # Escenario 3: Falta en un solo archivo
    print_style "👉 Se ha detectado una configuración de perfil incompleta. Elige una acción:" "$CYAN"
    PS3="Por favor, elige una opción: "

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
                print_style "✅ ¡Hecho! El código ha sido añadido a ~/.profile." "$GREEN"
                break
                ;;
            "Agregar código a ~/.bash_profile")
                echo "$codigo_a_anadir" >> ~/.bash_profile
                print_style "✅ ¡Hecho! El código ha sido añadido a ~/.bash_profile." "$GREEN"
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
    ensure_ssh_login_loads_bashrc # <-- AQUÍ SE EJECUTA LA NUEVA FUNCIÓN
    configure_timezone
    install_timeshift

    print_style "🎉 ¡Proceso de configuración completado! 🎉" "$MAGENTA"
}

# Ejecutar el script
main
