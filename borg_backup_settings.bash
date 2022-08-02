#!/bin/bash

# Borg Settings
export BORG_PASSPHRASE='YOUR_SAFE_PW_HERE'
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes

# Directories
export DATA_DIR="/path/to/nc-data/dir"
export BACKUP_DEST_DIR="/folder/for/borg/backup"

# Logging
export LOGGING_MAIL="your_personal@email.com"
export MAIL_SENDER="nextcloud@sender.com"
export LOG_DIR="~/borg_backup_logs"