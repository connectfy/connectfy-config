BASE_PATH="/home/$(whoami)/Desktop/Connectfy/"

i18n_projects=(
  "connectfy-auth"
  "connectfy-messenger"
  "connectfy-relationships"
  "connectfy-account"
  "connectfy-notifications"
  "connectfy-client"
  "connectfy-i18n",
  "connectfy-api-gateway"
)

echo -e "\n===================================================================="
echo -e "📝 Enter commit message:"
read commit_message

if [ -z "$commit_message" ]; then
  echo "❌ Commit message cannot be empty!"
  exit 1
fi

echo -e "\n===================================================================="
echo -e "🚀 Checking for changes and pushing...\n"

for project in "${i18n_projects[@]}"; do
  project_path="${BASE_PATH}${project}"

  if [ -d "$project_path" ]; then
    echo -e "\n📁 Project: $project"
    cd "$project_path"

    # Changes var?
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