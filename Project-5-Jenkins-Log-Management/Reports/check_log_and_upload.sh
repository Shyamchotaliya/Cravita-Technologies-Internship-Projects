#!/bin/bash


# ========================================================
# Log Archiver Script
# Checks log file size, compresses, uploads to S3, & rotates.
# ========================================================

#AWS CIL path 
export PATH=$PATH:/usr/local/bin 

# --- Configuration ---
LOG_FILE="/var/log/myapp/access.log"
S3_BUCKET="automatically-jenkins" 
SIZE_LIMIT_GB=1
SIZE_LIMIT_BYTES=$((SIZE_LIMIT_GB * 1024 * 1024 * 1024))

# --- Logic ---
echo "-------------------------------------------"
echo "Running Log Archiver check at $(date)"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    exit 1
fi

# Get the current size of the log file in bytes
CURRENT_SIZE_BYTES=$(stat -c%s "$LOG_FILE")
echo "Current log file size is: ${CURRENT_SIZE_BYTES} bytes."
echo "Size limit is: ${SIZE_LIMIT_BYTES} bytes."

# Check if the file size exceeds the limit
if [ "$CURRENT_SIZE_BYTES" -gt "$SIZE_LIMIT_BYTES" ]; then
    echo "Log file size exceeds ${SIZE_LIMIT_GB}GB. Starting archiving process..."

    # 1. Create a timestamp for the backup file
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    COMPRESSED_FILENAME="access_log_${TIMESTAMP}.zip"
    COMPRESSED_FILEPATH="/tmp/${COMPRESSED_FILENAME}" # Use /tmp for temporary storage

    # 2. Compress the log file
    echo "Compressing $LOG_FILE to $COMPRESSED_FILEPATH..."
    sudo zip -j "$COMPRESSED_FILEPATH" "$LOG_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to compress the log file."
        exit 1
    fi
    echo "Compression successful."

    # 3. Upload the compressed file to S3
    echo "Uploading $COMPRESSED_FILEPATH to s3://${S3_BUCKET}/..."
    aws s3 cp "$COMPRESSED_FILEPATH" "s3://${S3_BUCKET}/${COMPRESSED_FILENAME}"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to upload to S3."
        # Optional: Clean up compressed file on failure
        rm "$COMPRESSED_FILEPATH"
        exit 1
    fi
    echo "Upload to S3 successful."

    # 4. Clear the original log file (log rotation)
    echo "Clearing original log file: $LOG_FILE"
    sudo truncate -s 0 "$LOG_FILE"
    echo "Log file rotated successfully."

    # 5. Clean up the temporary compressed file
    rm "$COMPRESSED_FILEPATH"
    echo "Cleaned up temporary file."

else
    echo "Log file size is within the limit. No action needed."
fi

echo "Check complete."
echo "-------------------------------------------"