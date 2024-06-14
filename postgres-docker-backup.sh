#!/bin/bash

# Load environment
if [ -f .env ]; then
#  export "$(grep -v '^#' .env | xargs)"
  source "$(pwd)/.env"
fi

# PostgresSQL settings
container="$CONTAINER"
db_user="$DB_USER"
db_name="$DB_NAME" # Replace with the database name

echo "$container"

# Backup directory and filename on the local machine
LOCAL_BACKUP_DIR="/home/ubuntu/backups" # Replace with the directory where you want to store the backups
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
BACKUP_FILE="$LOCAL_BACKUP_DIR/$db_name-$TIMESTAMP.sql"

# Define a log file path
LOG_FILE="/home/ubuntu/db_logs/backup_script.log" # Replace with the directory where you want to store the logs

# Backup Retention Period
RETENTION_PERIOD=14 # You can modify the value as per your requirement

# Function to log messages
log_message() {
  local timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Run pg_dump inside the Docker container and save the backup file inside the container
docker exec -t "$container" pg_dump -U "$db_user" -F c -b -v -f "/tmp/$db_name-$TIMESTAMP.sql" "$db_name"

# Delay for 5 minutes for the backup to complete before continuing
sleep 300 # Value is in seconds, and can be modified as per your requirement

# Copy the backup file from the container to the local machine
docker cp "$container":/tmp/"$db_name"-"$TIMESTAMP".sql "$BACKUP_FILE"

# Check if the backup was successful
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
  log_message "Backup completed successfully: $BACKUP_FILE"
else
  log_message "Backup failed"
fi

# Delete backup files older than set retention period
find "$LOCAL_BACKUP_DIR" -type f -mtime +$RETENTION_PERIOD -exec rm {} \;
