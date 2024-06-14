#!/bin/bash

# Load environment
if [ -f .env ]; then
#  export "$(grep -v '^#' .env | xargs)"
  source "$(pwd)/.env"
fi

# Define variables
remote_server="$SERVER"
remote_user="$USER"
remote_password="$PASSWORD"
remote_directory="/home/ubuntu/backups"
local_directory="$HOME/Desktop/Workspace/scripts/backups"

# Check if variables are set
if [ -z "$remote_server" ] && [ -z "$remote_user" ] && [ -z "$remote_password" ]; then
  echo "Missing remote server, user, or password. Please, check the .env file."
  exit 1
fi

# Use sshpass and rsync to sync the remote directory to the local directory
sshpass -p "$remote_password" rsync -avz --progress --delete "$remote_user@$remote_server:$remote_directory/" "$local_directory/"

# Check the exit status of the rsync command
if sshpass -p "$remote_password" rsync -avz --progress --delete "$remote_user@$remote_server:$remote_directory/" "$local_directory/"; then
  message="Sync completed successfully"
else
  message="Sync failed with error code $?."
fi

# Send a notification to the user
echo "$message"

# Clear the password variable for security
unset remote_password
