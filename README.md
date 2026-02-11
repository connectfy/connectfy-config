Run all containers

1. docker compose -f kafka-compose.yml -f docker-compose.yml build
2. docker compose -f kafka-compose.yml -f docker-compose.yml up

// docker commands chmod +x create_networks.sh chmod 777 create_networks.sh sh create_networks.sh

Kafka commands:

1. List all Topics: kafka-topics.sh --bootstrap-server kafka-0:9092 --list

PSQL commands:

1. Connect to postgresSql: psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
2. Show tables: \dt;

ON MAC:

1. chmod +x create_networks.sh
2. chmod 777 create_networks.sh
3. sh create_networks.sh

4) chmod +x run_docker_services_mac.sh

5. ./run_docker_services_mac.sh

5) docker compose -f minio-docker.yml up

7. create access and secret key from minio admin panel http://localhost:9001/access-keys and place it at bmsv2-fileuploader/app.js with current

6) npx nodemon app.js 9) ngrok http http://localhost:9003

7) bmsv2-api-gateway/files.service.ts replace link inside
