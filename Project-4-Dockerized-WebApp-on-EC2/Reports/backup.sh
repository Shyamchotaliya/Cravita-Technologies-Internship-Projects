#!/bin/bash

# =================================================================
# Automated Backup & Rotation Script with Google Drive Integration
# =================================================================

# --- CONFIGURATION ---
PROJECT_DIR="/home/ubuntu/project-to-backup"
LOCAL_BACKUP_DIR="/home/ubuntu/backups/local"
GDRIVE_REMOTE="gdrive"
GDRIVE_BACKUP_DIR="Automated_Backups"
WEBHOOK_URL="[[YOUR-UNIQUE-WEBHOOK-URL]]" # Replace with your URL

# Retention policy
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=3

# --- SCRIPT LOGIC ---
echo "Starting backup for ${PROJECT_DIR}..."
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
BACKUP_FILENAME="backup_${TIMESTAMP}.zip"
LOCAL_BACKUP_PATH="${LOCAL_BACKUP_DIR}/${BACKUP_FILENAME}"

# 1. Create the .zip archive.
zip -r "${LOCAL_BACKUP_PATH}" "${PROJECT_DIR}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create zip archive."
    curl -X POST -H "Content-Type: application/json" -d "{\"status\":\"failure\",\"reason\":\"zip_failed\"}" "${WEBHOOK_URL}"
    exit 1
fi
BACKUP_SIZE=$(du -sh "${LOCAL_BACKUP_PATH}" | awk '{print $1}')
echo "Archive created: ${LOCAL_BACKUP_PATH} (Size: ${BACKUP_SIZE})"

# 2. Upload the backup to Google Drive.
echo "Uploading to Google Drive..."
rclone copy "${LOCAL_BACKUP_PATH}" "${GDRIVE_REMOTE}:${GDRIVE_BACKUP_DIR}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to upload to Google Drive."
    curl -X POST -H "Content-Type: application/json" -d "{\"status\":\"failure\",\"reason\":\"upload_failed\"}" "${WEBHOOK_URL}"
    exit 1
fi
echo "Upload successful."

# 3. Send success notification via webhook.
echo "Sending success webhook..."
curl -X POST -H "Content-Type: application/json" -d "{\"status\":\"success\",\"backup_file\":\"${BACKUP_FILENAME}\",\"size\":\"${BACKUP_SIZE}\"}" "${WEBHOOK_URL}"

# 4. Clean up local file and apply retention policy.
rm "${LOCAL_BACKUP_PATH}"
echo "Local archive deleted. Applying retention policy..."

# Delete old DAILY backups (keep last 7)
rclone lsf "${GDRIVE_REMOTE}:${GDRIVE_BACKUP_DIR}" | sort -r | tail -n +$((KEEP_DAILY + 1)) | while read -r file; do
    echo "Deleting old daily backup: $file"
    rclone deletefile "${GDRIVE_REMOTE}:${GDRIVE_BACKUP_DIR}/${file}"
done

echo "Backup process complete."