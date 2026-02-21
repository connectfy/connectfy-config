#!/bin/bash
BASE_PATH="/home/$(whoami)/Desktop/Connectfy/"

##########################################
# MODE SELECTION
##########################################
echo "Select operation mode:"
echo "  1) Commit (custom message)"
echo "  2) Package (auto i18n and shared commit)"
read -rp "Enter choice (1/2): " mode_choice

##########################################
# PROJECT LIST SELECTION
##########################################

if [ "$mode_choice" = "1" ]; then
  projects=(
    "connectfy-auth"
    "connectfy-messenger"
    "connectfy-relationships"
    "connectfy-account"
    "connectfy-notifications"
    "connectfy-client"
    "connectfy-i18n"
    "connectfy-api-gateway"
    "connectfy-shared"
    "connectfy-config"
  )

  echo -e "\n===================================================================="
  echo -e "📝 Enter commit message:"
  read -r commit_message

  if [ -z "$commit_message" ]; then
    echo "❌ Commit message cannot be empty!"
    exit 1
  fi

elif [ "$mode_choice" = "2" ]; then
  projects=(
    "connectfy-auth"
    "connectfy-messenger"
    "connectfy-relationships"
    "connectfy-account"
    "connectfy-notifications"
    "connectfy-client",
    "connectfy-shared"
  )

  commit_message="i18n && shared"

else
  echo "❌ Invalid choice"
  exit 1
fi

echo -e "\n===================================================================="
echo -e "🚀 Checking for changes and pushing...\n"

##########################################
# MAIN LOOP
##########################################

for project in "${projects[@]}"; do
  project_path="${BASE_PATH}${project}"

  if [ -d "$project_path" ]; then
    echo -e "\n📁 Project: $project"
    cd "$project_path" || continue

    if [[ -n $(git status --porcelain) ]]; then
      echo -e "📦 Changes detected — pushing..."
      git add .
      git commit -m "$commit_message"
      git push origin master
      echo -e "✅ Pushed successfully."
    else
      echo -e "⚪ No changes — skipping."
    fi
  else
    echo -e "\n⚠️  $project does not exist."
  fi
done

echo -e "\n===================================================================="
echo -e "✨ Done.\n"