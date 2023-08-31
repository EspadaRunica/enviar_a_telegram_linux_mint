#!/bin/bash

# Contenido para enviar_a_telegram.nemo_action
NEMO_ACTION_CONTENT="[Nemo Action]\nName=Enviar a Telegram\nName[pl]=Wyślij przez Telegram\nComment=Envía archivos a Telegram desde el menú contextual\nComment[pl]=Wysyła ten plik na czat w Telegramie\nQuote=double\nExec=/usr/share/nemo/actions/enviar_a_telegram.sh %F\nIcon-Name=org.telegram.desktop\nSelection=NotNone\nExtensions=nodirs;\nDependencies=telegram-desktop"

# Contenido para enviar_a_telegram.sh
SEND_SCRIPT_CONTENT='#!/usr/bin/env bash\n\narr=()\nSAVEIFS=$IFS\nIFS=$(echo -en "\n\b")\n\nfor var in "$@"\ndo\n    path=$(readlink -f $var)\n    arr+=($path)\ndone\n\n# Check if the client is a native app\nif [ $(command -v telegram-desktop) ]; then\n    telegram-desktop -sendpath "${arr[@]}"\n    wmctrl -x -a Telegram.TelegramDesktop\nelse\n    flatpak run --file-forwarding org.telegram.desktop -sendpath @@ "${arr[@]}" @@\n    wmctrl -x -a Telegram\nfi\n\nIFS=$SAVEIFS'

# Ruta donde se crearán los archivos
DESTINATION_DIR="/usr/share/nemo/actions/"

# Rutas completas para los archivos
NEMO_ACTION_FILE="$DESTINATION_DIR/enviar_a_telegram.nemo_action"
SEND_SCRIPT_FILE="$DESTINATION_DIR/enviar_a_telegram.sh"

# Verificar si el usuario tiene permisos de escritura en la carpeta de destino
if [ ! -w "$DESTINATION_DIR" ]; then
    echo "No tienes permisos para escribir en $DESTINATION_DIR. Ejecuta el script como administrador."
    exit 1
fi

# Crear el archivo enviar_a_telegram.nemo_action
echo -e "$NEMO_ACTION_CONTENT" > "$NEMO_ACTION_FILE"

# Dar permisos de ejecución al archivo enviar_a_telegram.sh
echo -e "$SEND_SCRIPT_CONTENT" > "$SEND_SCRIPT_FILE"
chmod +x "$SEND_SCRIPT_FILE"

# Mensaje de confirmación
echo "Archivos creados exitosamente en: $DESTINATION_DIR"

