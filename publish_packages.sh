#!/bin/bash

BASE_PATH="/home/$(whoami)/Desktop/Connectfy"

##########################################
# MODE SELECTION
##########################################
echo "Select operation mode:"
echo "  1) connectfy-i18n"
echo "  2) connectfy-shared"
echo "  3) both"
read -rp "Enter choice (1/2/3): " mode_choice

##########################################
# FUNCTION
##########################################
process_project () {
  PROJECT_NAME=$1
  PROJECT_PATH="$BASE_PATH/$PROJECT_NAME"

  echo "----------------------------------------"
  echo "Processing $PROJECT_NAME"
  echo "----------------------------------------"

  cd "$PROJECT_PATH" || { echo "Directory not found!"; exit 1; }

  # Check for changes
  if [[ -n $(git status --porcelain) ]]; then
    echo "Changes detected."

    git status

    read -rp "Enter commit message: " commit_message

    # Empty message check
    if [[ -z "$commit_message" ]]; then
      echo "Commit message cannot be empty!"
      exit 1
    fi

    git add .
    git commit -m "$commit_message"
  else
    echo "No changes to commit."
  fi

  echo "Pulling latest changes..."
  git pull --rebase || { echo "Pull failed"; exit 1; }

  echo "Bumping version..."
  npm version patch || { echo "Version bump failed"; exit 1; }

  echo "Publishing to npm..."
  npm publish || { echo "Publish failed"; exit 1; }

  echo "Pushing commits..."
  git push
  git push --tags

  echo "$PROJECT_NAME completed successfully!"
}

##########################################
# EXECUTION
##########################################
case $mode_choice in
  1)
    process_project "connectfy-i18n"
    ;;
  2)
    process_project "connectfy-shared"
    ;;
  3)
    process_project "connectfy-i18n"
    process_project "connectfy-shared"
    ;;
  *)
    echo "Invalid choice!"
    exit 1
    ;;
esac

echo "All done 🚀"