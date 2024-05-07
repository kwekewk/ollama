# Builder stage
#FROM debian:latest
FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

RUN apt update &&  apt install curl git build-essential libopenblas-dev wget python3-pip tmux sudo bash psmisc procps -y
RUN curl -fsSL https://ollama.com/install.sh | sh
ENV OLLAMA_HOST=0.0.0.0
RUN useradd -m appuser && chown -R appuser:appuser /home/appuser

# Create the directory and give appropriate permissions
RUN mkdir -p /home/appuser/.ollama && chmod 777 /home/appuser/.ollama

USER appuser
WORKDIR /home/appuser/.ollama

# Copy the entry point script
COPY --chown=appuser entrypoint.sh /entrypoint.sh
COPY --chown=appuser id_ed25519.pub /home/appuser/.ollama/id_ed25519.pub
RUN chmod +x /entrypoint.sh

# Set the entry point script as the default command
ENTRYPOINT ["/entrypoint.sh"]

# Set the model as an environment variable (this can be overridden)
ENV model="phi3:3.8b-mini-instruct-4k-q4_K_M"

# Expose the server port
EXPOSE 7860
