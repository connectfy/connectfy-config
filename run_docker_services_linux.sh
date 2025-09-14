#!/bin/bash

# Define the base path for directories
path="/home/$(whoami)/Desktop/connectfy/"

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
countdown 20


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
cd "${path}connectfy-config" && docker compose -f kafka-compose.yml up -d
echo -e "Kafka services are now running.\n"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 20


echo -e "Starting connectfy-auth service in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-auth" -- bash -c "cd ${path}connectfy-auth && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f auth-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 10


echo -e "Starting connectfy-notifications service in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-notifications" -- bash -c "cd ${path}connectfy-notifications && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f notification-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 10


echo -e "Starting connectfy-account service in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-account" -- bash -c "cd ${path}connectfy-account && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f notification-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 10


echo -e "Starting connectfy-relationships service in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-relationships" -- bash -c "cd ${path}connectfy-relationships && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f notification-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 10


echo -e "Starting connectfy-messenger service in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-notifications" -- bash -c "cd ${path}connectfy-messenger && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f notification-service; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 10


echo -e "Starting connectfy-api-gateway service in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-api-gateway" -- bash -c "cd ${path}connectfy-api-gateway && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f api-gateway; exec bash"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 10


echo -e "Starting connectfy-client in a new Terminal tab...\n"
gnome-terminal --tab --title="connectfy-client" -- bash -c "cd ${path}connectfy-client && docker compose -f docker-compose.dev.yml up -d --build && docker compose -f docker-compose.dev.yml logs -f client"
echo -e "===================================================================="
echo -e "====================================================================\n"
countdown 30


# echo -e "Starting Minio service...\n"
# cd "${path}bmsv2-fileuploader" && docker compose -f minio-compose.yml up -d
# echo -e "Minio service is now running.\n"
# echo -e "===================================================================="
# echo -e "====================================================================\n"
# countdown 5


# echo -e "Starting File Uploader application in a new Terminal tab...\n"
# gnome-terminal --tab -- bash -c "cd ${path}bmsv2-fileuploader && npx nodemon app.js; exec bash"
# echo -e "===================================================================="
# echo -e "====================================================================\n"
# countdown 10


# echo -e "Starting NGROK server in a new Terminal tab...\n"
# gnome-terminal --tab -- bash -c "cd ${path}bmsv2-fileuploader && ngrok http http://localhost:9003; exec bash"
# echo -e "===================================================================="
# echo -e "====================================================================\n"
# countdown 20


# echo -e "Opening Postman application...\n"
# xdg-open "postman://"
# echo -e "===================================================================="
# echo -e "====================================================================\n"

# Final log message
echo -e "\nAll tasks completed successfully! All services are now running.\n"
