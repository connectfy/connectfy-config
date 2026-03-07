#!/bin/bash

# Define the base path for directories
path="/home/$(whoami)/Desktop/Connectfy/"

# Countdown function to display remaining seconds
countdown() {
  local seconds=$1
  echo -e "\nCountdown started: $seconds seconds remaining."
  while [ $seconds -gt 0 ]; do
    echo -ne "Time left: $seconds seconds...\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo -e "\nCountdown complete.\n"
}


echo -e "\nStarting Docker..."
sudo systemctl start docker
echo -e "Waiting for Docker to initialize...\n"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5


echo -e "Stopping all running Docker containers...\n"

if docker stop $(docker ps -q) > /dev/null 2>&1; then
  echo -e "All running containers stopped successfully.\n"
else
  echo -e "No running containers to stop or an error occurred.\n"
fi

echo -e "===================================================================="
echo -e "====================================================================\n"


countdown 5


echo -e "Starting Kafka services...\n"
cd "${path}connectfy-config" && docker compose -f ./kafka/kafka-compose.yml up -d
echo -e "Kafka services are now running.\n"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5

# echo -e "Starting Redis...\n"
# cd "${path}connectfy-config" && docker compose -f ./redis/redis-compose.yml up -d
# echo -e "Redis are now running.\n"
# echo -e "===================================================================="
# echo -e "====================================================================\n"
# countdown 5


echo -e "Starting connectfy-auth service in a new Terminal tab...\n"
gnome-terminal --tab --title="auth" -- bash -c "cd ${path}connectfy-auth && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f auth-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5


echo -e "Starting connectfy-notification-action-history service in a new Terminal tab...\n"
gnome-terminal --tab --title="notification-action-history" -- bash -c "cd ${path}connectfy-notification-action-history && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f notification-action-history-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5


echo -e "Starting connectfy-account service in a new Terminal tab...\n"
gnome-terminal --tab --title="account" -- bash -c "cd ${path}connectfy-account && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f account-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5


#echo -e "Starting connectfy-relationship service in a new Terminal tab...\n"
#gnome-terminal --tab --title="relationship" -- bash -c "cd ${path}connectfy-relationship && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f relationship-service; exec bash"
#echo -e "===================================================================="
#echo -e "====================================================================\n"
#countdown 5
#
#
#echo -e "Starting connectfy-messenger service in a new Terminal tab...\n"
#gnome-terminal --tab --title="messenger" -- bash -c "cd ${path}connectfy-messenger && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f messenger-service; exec bash"
#echo -e "===================================================================="
#echo -e "====================================================================\n"
#countdown 5


echo -e "Starting connectfy-api-gateway service in a new Terminal tab...\n"
gnome-terminal --tab --title="api-gateway" -- bash -c "cd ${path}connectfy-api-gateway && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f api-gateway; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5


echo -e "Starting connectfy-client in a new Terminal tab...\n"
gnome-terminal --tab --title="client" -- bash -c "cd ${path}connectfy-client && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f client"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 5

# Final log message
echo -e "\nAll tasks completed successfully! All services are now running.\n"
