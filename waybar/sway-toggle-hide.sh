#!/bin/bash

STATE_FILE="/tmp/sway_dual_hide_state"

if [ ! -f "$STATE_FILE" ]; then
    # Attribue un workspace de stockage différent pour chaque écran (9 puis 8)
    hidden_ws=9
    
    # Récupère les workspaces visibles sur chaque écran et les sauvegarde
    while read -r output ws_name; do
        echo "$output $ws_name $hidden_ws" >> "$STATE_FILE"
        # Envoie les fenêtres de cet écran vers son workspace caché attitré
        swaymsg "[workspace=$ws_name] move container to workspace $hidden_ws"
        hidden_ws=$((hidden_ws - 1))
    done < <(swaymsg -t get_workspaces | jq -r '.[] | select(.visible == true) | "\(.output) \(.name)"')

    if [ ! -s "$STATE_FILE" ]; then
        rm -f "$STATE_FILE"
    fi
else
    # Restaure chaque écran sur son workspace d'origine à partir du fichier
    while read -r output ws_name hidden_ws; do
        swaymsg "[workspace=$hidden_ws] move container to workspace $ws_name"
    done < "$STATE_FILE"
    
    rm -f "$STATE_FILE"
fi