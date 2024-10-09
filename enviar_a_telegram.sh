#!/bin/bash

echo "   ____       _                         _                          "
echo "  / __ \  ___| |__  _ __ ___   ___   __| |_ __ ___   __ _ _____  __"
echo " / / _\` |/ __| '_ \| '_ \` _ \ / _ \ / _\` | '_ \` _ \ / _\` / __\ \/ /"
echo "| | (_| | (__| | | | | | | | | (_) | (_| | | | | | | (_| \__ \>  < "
echo " \ \__,_|\___|_| |_|_| |_| |_|\___/ \__,_|_| |_| |_|\__,_|___/_/\_\ "
echo "  \____/                                                           "
echo "En Dios confiamos | In God we trust"
echo ""


# Ruta donde se crearán los archivos
mkdir -p "/home/$USER/.local/share/nemo/actions/enviar-a-telegram@chmodmasx"
DESTINATION_DIR="/home/$USER/.local/share/nemo/actions"

# Rutas completas para los archivos
NEMO_ACTION_FILE="$DESTINATION_DIR/enviar_a_telegram.nemo_action"
SEND_SCRIPT_FILE="/home/$USER/.local/share/nemo/actions/enviar-a-telegram@chmodmasx/enviar_a_telegram.sh"

# Verificar si el usuario tiene permisos de escritura en la carpeta de destino
if [ ! -w "$DESTINATION_DIR" ]; then
    echo "No tienes permisos para escribir en $DESTINATION_DIR. Ejecuta el script como administrador."
    exit 1
fi

# Crear el archivo enviar_a_telegram.nemo_action
cat <<EOF > "$NEMO_ACTION_FILE"
[Nemo Action]
Name=Enviar a Telegram
Name[pl]=Wyślij przez Telegram
Comment=Envía archivos a Telegram desde el menú contextual
Comment[pl]=Wysyła ten plik na czat w Telegramie
Quote=double
Exec=/home/$USER/.local/share/nemo/actions/enviar-a-telegram@chmodmasx/enviar_a_telegram.sh %F
Icon-Name=org.telegram.desktop
Selection=NotNone
Extensions=nodirs;
EOF

# Crear el archivo enviar_a_telegram.sh
cat <<EOF > "$SEND_SCRIPT_FILE"
#!/usr/bin/env bash

arr=()
SAVEIFS=\$IFS
IFS=\$(echo -en "\n\b")

for var in "\$@"
do
    # Verificar si la variable no está vacía
    if [ -n "\$var" ]; then
        path=\$(readlink -f "\$var")
        arr+=("\$path")
    fi
done

# Check if the client is a native app
if command -v telegram-desktop > /dev/null; then
    telegram-desktop -sendpath "\${arr[@]}"
    wmctrl -x -a Telegram.TelegramDesktop
elif command -v telegram > /dev/null; then
    telegram -sendpath "\${arr[@]}"
    wmctrl -x -a Telegram.TelegramDesktop
else
    flatpak run --file-forwarding org.telegram.desktop -sendpath @@ "\${arr[@]}" @@
    wmctrl -x -a Telegram
fi

IFS=\$SAVEIFS
EOF

# Dar permisos de ejecución al archivo enviar_a_telegram.sh
chmod +x "$SEND_SCRIPT_FILE"

# Mensaje de confirmación
echo "Archivos creados exitosamente en: $DESTINATION_DIR"
