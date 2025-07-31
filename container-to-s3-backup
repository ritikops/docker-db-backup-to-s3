#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Date variables
DATE=$(date +%Y/%m/%d)
TODAY=$(date +%Y-%m-%d)

# Configuration
BUCKET="iqit-backups"
MYSQL_CONTAINER="fiscus-db"
MYSQL_USER="root"  # Fixed typo: was MYS_USER
MYSQL_PASSWORD="root_password"

# Backup paths
MYSQL_BACKUP="/tmp/fiscus_db_backup_$TODAY.sql"
MYSQL_S3_PATH="s3://$BUCKET/fiscus_db/$DATE/fiscus_db_backup_$TODAY.sql"

echo "Starting MySQL backup for fiscus_db..."
echo "Target S3 path: $MYSQL_S3_PATH"

# Create MySQL backup - CORRECTED COMMAND
# Changed from: MYSQL_dumpall -U $MYSQL_USER
# To: mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD --databases fiscus_db
docker exec $MYSQL_CONTAINER mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD --databases fiscus_db --routines --triggers > $MYSQL_BACKUP

# Check if backup was created successfully
if [ $? -eq 0 ] && [ -s "$MYSQL_BACKUP" ]; then
    echo "MySQL backup created successfully"
    
    # Get backup file size
    BACKUP_SIZE=$(du -h "$MYSQL_BACKUP" | cut -f1)
    echo "Backup file size: $BACKUP_SIZE"
    
    # Upload to S3
    echo "Uploading to S3..."
    aws s3 cp "$MYSQL_BACKUP" "$MYSQL_S3_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Backup uploaded successfully to: $MYSQL_S3_PATH"
    else
        echo "ERROR: Failed to upload backup to S3"
        exit 1
    fi
else
    echo "ERROR: Failed to create MySQL backup"
    exit 1
fi

# Clean up temporary files - REMOVED UNDEFINED VARIABLES
rm -f "$MYSQL_BACKUP"

echo "Backup process completed successfully!"
