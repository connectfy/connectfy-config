#!/bin/bash

# Define the base path for repositories
BASE_PATH="/home/$(whoami)/Desktop/connectfy/"

# Define all your project folders here
projects=(
  "connectfy-config"
  "connectfy-auth"
  "connectfy-messenger"
  "connectfy-relationships"
  "connectfy-account"
  "connectfy-notifications"
  "connectfy-api-gateway"
  "connectfy-client"
)

echo -e "\nStarting git pull for all projects...\n"
echo -e "===================================================================="

for project in "${projects[@]}"; do
  project_path="${BASE_PATH}${project}"
  if [ -d "$project_path/.git" ]; then
    echo -e "\n📦 Pulling updates for: $project"
    cd "$project_path"
    git pull
  else
    echo -e "\n⚠️  $project is not a Git repository or does not exist."
  fi
done

echo -e "\n===================================================================="
echo -e "✅ All git pull operations completed.\n"
