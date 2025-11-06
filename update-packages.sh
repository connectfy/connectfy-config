BASE_PATH="/home/$(whoami)/Desktop/Connectfy/"

i18n_projects=(
  "connectfy-auth"
  "connectfy-messenger"
  "connectfy-relationships"
  "connectfy-account"
  "connectfy-notifications"
  "connectfy-client"
)

echo -e "\n===================================================================="
echo -e "🌐 Updating connectfy-i18n package in selected projects...\n"

for project in "${i18n_projects[@]}"; do
  project_path="${BASE_PATH}${project}"
  if [ -d "$project_path" ]; then
    echo -e "\n📦 Installing latest connectfy-i18n in: $project"
    cd "$project_path"
    npm i connectfy-i18n@latest
  else
    echo -e "\n⚠️  $project does not exist."
  fi
done

echo -e "\n===================================================================="
echo -e "✅ All operations completed.\n"