#!/bin/bash
set -e

##########################################
# OS SELECTION
##########################################
echo "Select your operating system:"
echo "  1) Linux"
echo "  2) macOS"
read -rp "Enter choice (1/2): " os_choice

case "$os_choice" in
  1)
    BASE_RIFAH="/home/$(whoami)/Desktop/khamsa/rifah"
    BASE_OPS="/home/$(whoami)/Desktop/khamsa/ops"
    ;;
  2)
    BASE_RIFAH="/Users/$(whoami)/Desktop/khamsa/rifah"
    BASE_OPS="/Users/$(whoami)/Desktop/khamsa/ops"
    ;;
  *)
    echo "❌ Invalid choice"
    exit 1
    ;;
esac

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

##########################################
# GIT PULL FOR ALL PROJECTS
##########################################
for item in "${projects[@]}"; do
  IFS=":" read -r scope project <<< "$item"
  base="$(get_base_by_scope "$scope")"
  project_path="${base}/${project}"

  if [ -d "$project_path/.git" ]; then
    echo -e "\n📦 Pulling updates for: $project ($scope)"
    cd "$project_path"
    git pull
  else
    echo -e "\n⚠️  $project is not a Git repository or does not exist at: $project_path"
  fi
done
