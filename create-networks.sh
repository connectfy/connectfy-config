#!/bin/bash

docker network create kafka_network
docker network create api-gateway-network
# docker network create main-network
docker network create auth-network
docker network create messenger-network
docker network create relationships-network
docker network create account-network
docker network create notifications-network
