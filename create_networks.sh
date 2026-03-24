#!/bin/bash

create_network () {
  local NETWORK_NAME=$1

  if docker network inspect $NETWORK_NAME >/dev/null 2>&1; then
    echo "✔ Network $NETWORK_NAME already exists"
  else
    echo "🚀 Creating network $NETWORK_NAME"
    docker network create $NETWORK_NAME
  fi
}

create_network connectfy-core-network
create_network connectfy-kafka-network
create_network connectfy-redis-network
create_network connectfy-file-service-network

create_network auth-db-network
create_network account-db-network
create_network notification-db-network


echo "All networks ready."