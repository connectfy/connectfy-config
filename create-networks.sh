#!/bin/bash

docker network create connectfy_kafka_network
docker network create connectfy-api-gateway-network
# docker network create main-network
docker network create connectfy-auth-network
docker network create connectfy-messenger-network
docker network create connectfy-relationships-network
docker network create connectfy-account-network
docker network create connectfy-notifications-network
