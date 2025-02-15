#!/bin/bash

# Trouver le PID du processus écoutant sur le port 3000
PID=$(lsof -i :3000 -t)

if [ -z "$PID" ]; then
    echo "Aucun processus ne tourne sur le port 3000."
    exit 1
fi

echo "Processus trouvé avec PID : $PID"

# Vérifier si le processus est un service géré par systemd
SERVICE_NAME=$(systemctl list-units --type=service --all | grep "$PID" | awk '{print $1}')

if [ -n "$SERVICE_NAME" ]; then
    echo "Récupération des logs via journalctl pour le service $SERVICE_NAME..."
    journalctl -u "$SERVICE_NAME" -f
else
    # Chercher un éventuel fichier log dans /var/log ou le home de l'utilisateur
    LOG_FILE=$(ls -1 /var/log/*.log 2>/dev/null | grep -i 'app\|server' | head -n 1)

    if [ -n "$LOG_FILE" ]; then
        echo "Affichage des logs depuis : $LOG_FILE"
        tail -f "$LOG_FILE"
    else
        echo "Impossible de déterminer où sont stockés les logs. Essayez de les récupérer manuellement avec :"
        echo "strace -p $PID -e write"
    fi
fi

