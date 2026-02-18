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
    # Adjust this to the actual parent folder where your projects live
    BASE_DIR="/home/$(whoami)/Desktop/Connectfy"
    ;;
  2)
    BASE_DIR="/Users/$(whoami)/Desktop/Connectfy"
    ;;
  *)
    echo "❌ Invalid choice"
    exit 1
    ;;
esac

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

for item in "${projects[@]}"; do
  # Use the Absolute Path defined in BASE_DIR
  project_path="${BASE_DIR}/${item}"

  if [ -d "$project_path/.git" ]; then
    echo -e "\n📦 Pulling updates for: $item"
    # Use a subshell ( ) so the "cd" doesn't affect the next loop iteration
    (
      cd "$project_path"
      git pull
    )
  else
    echo -e "\n⚠️  $item is not a Git repository or does not exist at: $project_path"
  fi
donec