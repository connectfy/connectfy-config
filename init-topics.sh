#!/usr/bin/env bash
# Creates Kafka topics by exec'ing into a running broker container (Option 2).
# Reads topics from an external file if provided/exists; falls back to built-in list.

set -euo pipefail

# --- Config ---------------------------------------------------------------
BROKER_CONTAINER="${BROKER_CONTAINER:-kafka-0}"                 # container name to exec into
BOOTSTRAP="${BOOTSTRAP:-kafka-0:9092,kafka-1:9092}"             # bootstrap servers (as seen from inside containers)

PARTITIONS="${PARTITIONS:-3}"
REPLICATION="${REPLICATION:-2}"
READY_TIMEOUT_SEC="${READY_TIMEOUT_SEC:-180}"

# Optional external topics file (one topic per line; '#' comments allowed)
TOPICS_FILE="${TOPICS_FILE:-./topics.txt}"

# Built-in fallback topic list
FALLBACK_TOPICS=(
  "TEST.TOPIC.NAME"
)
# -------------------------------------------------------------------------

# --- Helpers --------------------------------------------------------------
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: '$1' is required but not found in PATH." >&2
    exit 1
  }
}

docker_exec() {
  docker exec -i "${BROKER_CONTAINER}" "$@"
}

kafka_topics() {
  docker_exec kafka-topics "$@"
}

topic_exists() {
  topic_name="$1"
  kafka_topics --bootstrap-server "${BOOTSTRAP}" --list 2>/dev/null | grep -xq "${topic_name}"
}

first_bootstrap_host() {
  echo "${BOOTSTRAP}" | awk -F',' '{print $1}'
}

load_topics_from_file() {
  local file="$1"
  local -a loaded=()
  if [ -f "$file" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
      # Trim leading/trailing whitespace
      line="$(echo "$line" | awk '{$1=$1;print}')"
      # Skip blanks and comments
      [ -z "$line" ] && continue
      case "$line" in
        \#*) continue ;;
      esac
      loaded+=("$line")
    done < "$file"
  fi

  # Export as global TOPICS array
  if [ "${#loaded[@]}" -gt 0 ]; then
    TOPICS=("${loaded[@]}")
    echo "Loaded ${#TOPICS[@]} topics from: $file"
  else
    TOPICS=("${FALLBACK_TOPICS[@]}")
    if [ -f "$file" ]; then
      echo "Warning: '$file' was empty or had only comments. Using fallback topics."
    else
      echo "Info: '$file' not found. Using fallback topics."
    fi
  fi
}

# --- Checks ---------------------------------------------------------------
require_cmd docker

# Ensure container is running
if ! docker ps --format '{{.Names}}' | grep -qx "${BROKER_CONTAINER}"; then
  echo "ERROR: Container '${BROKER_CONTAINER}' is not running."
  echo "       Start your stack (e.g., 'docker compose up -d') and try again."
  exit 1
fi

# Load topics
load_topics_from_file "${TOPICS_FILE}"

echo "Using broker container: ${BROKER_CONTAINER}"
echo "Bootstrap servers: ${BOOTSTRAP}"
echo "Partitions: ${PARTITIONS} | Replication: ${REPLICATION}"

# --- Wait for broker readiness -------------------------------------------
echo "Waiting for Kafka to become ready (timeout: ${READY_TIMEOUT_SEC}s)..."
deadline=$(($(date +%s) + READY_TIMEOUT_SEC))
BOOTSTRAP_FIRST="$(first_bootstrap_host)"

while true; do
  if kafka_topics --bootstrap-server "${BOOTSTRAP_FIRST}" --list >/dev/null 2>&1; then
    sleep 3
    echo "Kafka is ready."
    break
  fi
  now=$(date +%s)
  if [ "${now}" -ge "${deadline}" ]; then
    echo "ERROR: Timed out waiting for Kafka readiness." >&2
    exit 1
  fi
  echo "  ...not ready yet, retrying in 5s"
  sleep 5
done

# --- Create topics --------------------------------------------------------
create_topic() {
  topic="$1"

  if topic_exists "${topic}"; then
    echo "• ${topic} (already exists) — skipped"
    return 0
  fi

  if kafka_topics \
      --bootstrap-server "${BOOTSTRAP}" \
      --create \
      --topic "${topic}" \
      --partitions "${PARTITIONS}" \
      --replication-factor "${REPLICATION}" \
      --if-not-exists >/dev/null 2>&1
  then
    echo "✔ ${topic}"
  else
    # race-safe recheck
    if topic_exists "${topic}"; then
      echo "• ${topic} (already existed after race) — skipped"
      return 0
    fi
    echo "✖ Failed to create ${topic}" >&2
    return 1
  fi
}

RC=0
for t in "${TOPICS[@]}"; do
  if ! create_topic "$t"; then
    RC=1
  fi
done

if [ "${RC}" -eq 0 ]; then
  echo "All topics created successfully ✅"
else
  echo "Finished with some errors. Check logs above. ❗"
fi





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
