#!/bin/bash
create_network() {
  local name="$1"

  if docker network inspect "$name" >/dev/null 2>&1; then
    echo "Network '$name' already exists. Skipping."
  else
    echo "Creating network '$name'..."
    docker network create "$name"
  fi
}

create_network "connectfy-kafka-network"
create_network "connectfy-api-gateway-network"
create_network "connectfy-auth-network"
create_network "connectfy-messenger-network"
create_network "connectfy-relationships-network"
create_network "connectfy-account-network"
create_network "connectfy-notifications-network"
create_network "connectfy-file-service-network"

