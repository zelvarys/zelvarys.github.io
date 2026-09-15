#!/data/data/com.termux/files/usr/bin/bash

# Folders
LOCAL="/storage/emulated/0/whatsapp-bot"
TERMUX_HOME="/data/data/com.termux/files/home/bot"

# Initial sync
echo "Initial sync..."
rsync -av --delete --exclude='node_modules' --exclude='.git' --exclude='package-lock.json' "$LOCAL/" "$TERMUX_HOME/"

# Watch for changes
echo "Watching for changes in $LOCAL ..."
while true; do
    inotifywait -r -e modify,create,delete,move "$LOCAL" --exclude '(node_modules|\.git|package-lock\.json)'
    echo "Change detected. Syncing..."
    rsync -av --delete --exclude='node_modules' --exclude='.git' --exclude='package-lock.json' "$LOCAL/" "$TERMUX_HOME/"
done
