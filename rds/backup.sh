#!/bin/bash

# Load environment
if [ -f .env ]; then
  source .env
fi

# Define variables
host="$HOST"
user="$USER"
password="$PASSWORD"
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
backup_path="/home/caleb/Desktop/Workspace/scripts/rds"
backup_file="$backup_path/$host-$timestamp.sql"
bucket="$BUCKET"

#psql -h "$host" -U "$user" -W

PGPASSWORD="$password" pg_dumpall -h "$host" -U "$user" -f "$backup_file"

if PGPASSWORD="$password" pg_dumpall -h "$host" -U "$user" --no-role-passwords -f "$backup_file"; then
  aws s3 cp "$backup_file" s3://"$bucket"

  if aws s3 cp "$backup_file" s3://"$bucket"; then
    echo "Backup completed successfully"
    rm "$backup_file"
  else
    echo "Backup failed"
  fi
fi


## Check if variables are set
#if [ -z "$host" ] && [ -z "$user" ] && [ -z "$password" ]; then
#  echo "Missing hostname, user, or password. Please, check the .env file."
#  exit 1
#fi
#
#echo databases=$(psql -U "$user" -h "$host" -c "\l" | awk 'NR>2 {print $1}' | grep -vE 'Database')
#
#for DATABASE_NAME in $databases; do
#  echo "Backing up $host"
#
#  pg_dumpall -h $host -U $user -f $backup_path
#done



