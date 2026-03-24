#!/bin/bash

# 1. PATH Problemini Həll Edirik (Komandaların tapılması üçün)
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 2. Bazanı təyin edirik
BASE_PATH="/home/$(whoami)/Desktop/Connectfy/"

# 3. Zsh olub-olmadığını yoxlayırıq
if command -v zsh >/dev/null 2>&1; then
  SHELL_CMD="zsh"
else
  SHELL_CMD="bash"
fi

# Geri sayım funksiyası
countdown() {
  local seconds=$1
  echo -e "\nCountdown: $seconds seconds..."
  while [ $seconds -gt 0 ]; do
    echo -ne "Time left: $seconds...\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo -e "\nDone.\n"
}

# Servis başlatma funksiyası (Kod təkrarını önləyir)
start_service() {
  local title=$1
  local folder=$2
  local service_name=$3
  
  echo -e "Starting: $title service...\n"
  gnome-terminal --tab --title="$title" -- $SHELL_CMD -c "cd ${BASE_PATH}${folder} && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f ${service_name}; exec $SHELL_CMD"
  echo -e "===================================================================="
  countdown 3
}

# --- İCRA HİSSƏSİ ---

echo -e "\nStarting Docker..."
sudo systemctl start docker

echo -e "Stopping running containers..."
docker stop $(docker ps -q) > /dev/null 2>&1

countdown 2

echo -e "Starting Kafka..."
cd "${BASE_PATH}connectfy-config" && docker compose -f ./kafka/kafka-compose.yml up -d
countdown 10

echo -e "Starting Redis..."
cd "${BASE_PATH}connectfy-config" && docker compose -f ./redis/redis-compose.yml up -d
countdown 10

# --- Servisləri Sıra ilə Başlat ---
# Format: start_service "Tab Başlığı" "Qovluq Adı" "Docker Service Adı"

start_service "auth" "connectfy-auth" "auth-service"
start_service "notification" "connectfy-notification-action-history" "notification-action-history-service"
start_service "account" "connectfy-account" "account-service"
start_service "file-uploader" "connectfy-file-uploader" "file-uploader"
start_service "api-gateway" "connectfy-api-gateway" "api-gateway"
start_service "client" "connectfy-client" "client"

echo -e "\nAll services are running! Terminal: $SHELL_CMD\n"