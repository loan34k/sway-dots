#!/bin/bash

# Vérifie si un joueur est actif
PLAYER=$(playerctl --list-all 2>/dev/null | head -n 1)
if [ -z "$PLAYER" ]; then
    echo ""
    exit 0
fi

# Vérifie le statut
STATUS=$(playerctl status 2>/dev/null)

# Récupère les métadonnées et échappe le '&' pour Pango/Waybar
ARTIST=$(playerctl metadata artist 2>/dev/null | head -c 15 | sed 's/&/\&amp;/g')
TITLE=$(playerctl metadata title 2>/dev/null | head -c 20 | sed 's/&/\&amp;/g')
ALBUM=$(playerctl metadata album 2>/dev/null | head -c 15 | sed 's/&/\&amp;/g')

if [ "$STATUS" = "Playing" ]; then
    # Si artist ou title est vide, on affiche juste le titre ou "Playing"
    if [ -z "$ARTIST" ] && [ -z "$TITLE" ]; then
        echo "⏯ Playing"
    elif [ -z "$ARTIST" ]; then
        echo "⏯ $TITLE"
    else
        echo "⏯ $ARTIST - $TITLE"
    fi
elif [ "$STATUS" = "Paused" ]; then
    if [ -z "$ARTIST" ] && [ -z "$TITLE" ]; then
        echo "⏸ Paused"
    elif [ -z "$ARTIST" ]; then
        echo "⏸ $TITLE (Paused)"
    else
        echo "⏸ $ARTIST - $TITLE (Paused)"
    fi
else
    echo ""
fi