#!/bin/bash

# ================================
#  Cleanup Connectfy dev containers
#  Remove their images (except mongo, kafka, kafka-ui)
#  Remove <none> images
# ================================

containers=(
  "connectfy-client-dev"
  "connectfy-api-gateway-dev"
  "connectfy-messenger-service-dev"
  "connectfy-messenger-mongo-dev"
  "connectfy-relationships-service-dev"
  "connectfy-relationships-mongo-dev"
  "connectfy-account-service-dev"
  "connectfy-account-mongo-dev"
  "connectfy-notifications-service-dev"
  "connectfy-notifications-mongo-dev"
  "connectfy-auth-service-dev"
  "connectfy-auth-mongo-dev"
  "kafka-ui"
  "kafka-0"
  "kafka-1"
)

echo -e "\n==============================="
echo -e "🛑 Stopping & removing containers"
echo -e "==============================="

for cname in "${containers[@]}"; do
  echo -e "\n📦 Processing: $cname"

  if docker ps -a --format '{{.Names}}' | grep -w "$cname" > /dev/null; then

    # Get image ID (before removing container)
    image_id=$(docker inspect --format='{{.Image}}' "$cname")

    echo "➡️  Stopping $cname..."
    docker stop "$cname"

    echo "➡️  Removing $cname..."
    docker rm "$cname"

    # --- IMAGE DELETE PART ---
    # If image tag contains "mongo", "kafka", or "kafka-ui", DO NOT DELETE
    image_tag=$(docker image inspect "$image_id" --format '{{index .RepoTags 0}}' 2>/dev/null)

    if [[ "$image_tag" == *"mongo"* ]] || [[ "$image_tag" == *"kafka"* ]]; then
      echo "⏭️  Infrastructure image detected → NOT deleted: $image_tag"
      continue
    fi

    # Delete non-infrastructure images (only Connectfy service images)
    if [ -n "$image_id" ]; then
      echo "🧹 Removing image: $image_id"
      docker rmi "$image_id" 2>/dev/null || \
        echo "⚠️  Image still in use or already removed."
    fi

  else
    echo "⚠️  Container $cname not found."
  fi
done

echo -e "\n==============================="
echo -e "🧹 Removing <none> dangling images"
echo -e "==============================="

docker images -f "dangling=true" -q | xargs -r docker rmi

echo -e "\n==============================="
echo -e "✅ Cleanup completed!"
echo -e "===============================\n"