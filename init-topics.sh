#!/bin/bash
# sleep 30

until kafka-topics.sh --bootstrap-server kafka-0:9092 --list; do
  echo "Waiting for Kafka to be ready..."
  sleep 5
done


# NOTIFICATION TOPICS
kafka-topics.sh --create --topic mail.send --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic mail.send.reply --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

# ACCOUNT TOPICS
kafka-topics.sh --create --topic account.deleteAccount.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic account.deleteSocialLink.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic account.deletePrivacySetting.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

echo "Topics created successfully !!!"
