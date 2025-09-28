#!/bin/bash
# sleep 30

until kafka-topics.sh --bootstrap-server kafka-0:9092 --list; do
  echo "Waiting for Kafka to be ready..."
  sleep 5
done


# AUTH NOTIFICATION TOPICS
kafka-topics.sh --create --topic auth.account.deleteAccount.completed --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic auth.account.deleteSocialLink.completed --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic auth.account.deletePrivacySetting.completed --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic auth.relationship.deleteFriendship.completed --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic auth.relationship.deleteBlocklist.completed --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic auth.notification.deleteNotifications.completed --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

# NOTIFICATION TOPICS
kafka-topics.sh --create --topic notification.deleteNotifications --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic mail.send --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
# kafka-topics.sh --create --topic mail.send.reply --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

# ACCOUNT TOPICS
kafka-topics.sh --create --topic account.deleteAccount.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic account.deleteSocialLink.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic account.deletePrivacySetting.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

# RELATIONSHIP TOPICS
kafka-topics.sh --create --topic relationship.deleteFriendship.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2
kafka-topics.sh --create --topic relationship.deleteBlocklist.create --bootstrap-server kafka-0:9092,kafka-1:9092 --partitions 3 --replication-factor 2

echo "Topics created successfully !!!"
