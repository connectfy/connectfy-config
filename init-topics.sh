#!/bin/bash
# sleep 30

until kafka-topics.sh --bootstrap-server kafka-0:9092 --list; do
  echo "Waiting for Kafka to be ready..."
  sleep 5
done


# NOTIFICATION TOPICS
kafka-topics.sh --create --topic mail.send --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic mail.send.reply --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2


# # CRM ADD NOTIFICATION
# kafka-topics.sh --create --topic crm.customer.notification.add --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.customer.actionHistory.add --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.settings.notification.add --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.settings.actionHistory.add --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.settings.notification.add.bulk --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.settings.actionHistory.add.bulk --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.customer.notification.add.bulk --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.customer.actionHistory.add.bulk --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# # CRM IMPORT TOPICS
# kafka-topics.sh --create --topic crm.customer.import.read.file --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.customer.import.read.file.reply --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.customer.bulk.insert --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic crm.customer.bulk.insert.reply --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# # CRM IMPORT TOPICS

# # STORE MANAGEMENT ADD NOTIFICATION
# kafka-topics.sh --create --topic store.management.settings.notification.add --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic store.management.settings.actionHistory.add --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic store.management.settings.notification.add.bulk --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic store.management.settings.actionHistory.add.bulk --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# # STORE MANAGEMENT ADD NOTIFICATION

# kafka-topics.sh --create --topic notificationTopic.reply --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

echo "Topics created successfully !!!"
