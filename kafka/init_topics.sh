#!/usr/bin/env bash
set -euo pipefail

# ==============================
# CONFIG
# ==============================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOPICS_FILE="${TOPICS_FILE:-${SCRIPT_DIR}/topics.txt}"

BROKER_CONTAINER="${BROKER_CONTAINER:-kafka-0}"
BOOTSTRAP="${BOOTSTRAP:-kafka-0:9092,kafka-1:9092}"

PARTITIONS="${PARTITIONS:-3}"
REPLICATION="${REPLICATION:-2}"
READY_TIMEOUT_SEC="${READY_TIMEOUT_SEC:-180}"

# ==============================
# LOG HELPERS
# ==============================

log()  { echo -e "\033[1;34m[INFO]\033[0m  $1"; }
ok()   { echo -e "\033[1;32m[OK]\033[0m    $1"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m  $1"; }
err()  { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# ==============================
# CHECKS
# ==============================

command -v docker >/dev/null 2>&1 || {
  err "Docker not found."
  exit 1
}

if ! docker ps --format '{{.Names}}' | grep -qx "${BROKER_CONTAINER}"; then
  err "Container '${BROKER_CONTAINER}' is not running."
  exit 1
fi

# ==============================
# LOAD TOPICS
# ==============================

if [ ! -f "${TOPICS_FILE}" ]; then
  err "topics.txt not found at: ${TOPICS_FILE}"
  exit 1
fi

TOPICS=()
while IFS= read -r line || [ -n "$line" ]; do
  line="$(echo "$line" | xargs)"   # trim whitespace
  [[ -z "$line" ]] && continue
  [[ "$line" =~ ^# ]] && continue
  TOPICS+=("$line")
done < "${TOPICS_FILE}"

if [ "${#TOPICS[@]}" -eq 0 ]; then
  err "topics.txt is empty."
  exit 1
fi

log "Loaded ${#TOPICS[@]} topics from topics.txt"
log "Broker container: ${BROKER_CONTAINER}"
log "Bootstrap: ${BOOTSTRAP}"
log "Partitions: ${PARTITIONS} | Replication: ${REPLICATION}"

# ==============================
# WAIT FOR KAFKA
# ==============================

log "Waiting for Kafka to become ready..."

deadline=$(($(date +%s) + READY_TIMEOUT_SEC))
FIRST_BOOTSTRAP="$(echo "${BOOTSTRAP}" | awk -F',' '{print $1}')"

while true; do
  if docker exec "${BROKER_CONTAINER}" \
      kafka-topics --bootstrap-server "${FIRST_BOOTSTRAP}" --list \
      >/dev/null 2>&1; then
    ok "Kafka is ready."
    break
  fi

  if [ "$(date +%s)" -ge "${deadline}" ]; then
    err "Timed out waiting for Kafka."
    exit 1
  fi

  sleep 5
done

# ==============================
# HELPERS
# ==============================

topic_exists() {
  docker exec "${BROKER_CONTAINER}" \
    kafka-topics \
    --bootstrap-server "${BOOTSTRAP}" \
    --list 2>/dev/null | grep -xq "$1"
}

create_topic() {
  local topic="$1"

  if topic_exists "${topic}"; then
    warn "${topic} already exists — skipped"
    return 0
  fi

  if docker exec "${BROKER_CONTAINER}" \
      kafka-topics \
      --bootstrap-server "${BOOTSTRAP}" \
      --create \
      --topic "${topic}" \
      --partitions "${PARTITIONS}" \
      --replication-factor "${REPLICATION}" \
      --if-not-exists >/dev/null 2>&1
  then
    ok "Created ${topic}"
  else
    if topic_exists "${topic}"; then
      warn "${topic} created in race condition — skipped"
      return 0
    fi
    err "Failed to create ${topic}"
    return 1
  fi
}

# ==============================
# CREATE TOPICS
# ==============================

RC=0

for topic in "${TOPICS[@]}"; do
  if ! create_topic "${topic}"; then
    RC=1
  fi
done

if [ "${RC}" -eq 0 ]; then
  ok "All topics processed successfully."
else
  err "Some topics failed."
fi

exit "${RC}"




# ========================= EXAMPLE FOR CREATING A TOPIC =========================
# ========================= EXAMPLE FOR CREATING A TOPIC =========================
# ===========================================================================
# ===========================================================================
# docker exec -it kafka-0 kafka-topics \
#   --bootstrap-server kafka-0:9092,kafka-1:9092 \
#   --create \
#   --topic myNewTopic \
#   --partitions 3 \
#   --replication-factor 2 \
#   --if-not-exists
# ===========================================================================
# ===========================================================================
# ========================= EXAMPLE FOR CREATING A TOPIC =========================
# ========================= EXAMPLE FOR CREATING A TOPIC =========================
