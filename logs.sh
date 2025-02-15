#!/bin/bash

PORT=3001  # Remplacez par le port de votre application

# Utiliser le premier argument comme nom de fichier de log, ou "logfile.log" par défaut
LOG_FILE=${1:-logfile.log}

# Création du fichier de log
touch "$LOG_FILE"

# Vérifier si le port est en écoute
if lsof -i :$PORT > /dev/null 2>&1; then
    echo "L'application est en écoute sur le port $PORT."
    echo "Affichage des logs en temps réel :"
    tail -f "$LOG_FILE"
else
    echo "Aucune application n'écoute sur le port $PORT."
    exit 1  # Quitter avec un code d'erreur
fi
