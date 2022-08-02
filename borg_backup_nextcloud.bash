#!/bin/bash
##################################
### Based on https://www.c-rieger.de/backup-mit-de-duplizierung/
##################################

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${SCRIPTPATH}/borg_settings.bash"

startTime=$(date +%s)
currentDate=$(date --date @"$startTime" +"%Y%m%d_%H%M%S")
currentDateReadable=$(date --date @"$startTime" +"%d.%m.%Y - %H:%M:%S")
logDirectory="${LOG_DIR}"
logFile="${logDirectory}/${currentDate}.log"
backupDiscMount="${BACKUP_DEST_DIR}"
borgRepository="${backupDiscMount}/data"
borgBackupDirs="${DATA_DIR}"
dockerContainerName="ncp_container"
if [ ! -d "${logDirectory}" ]
then
        mkdir -p "${logDirectory}"
fi
errorecho() { cat <<< "$@" 1>&2; }
exec > >(tee -i "${logFile}")
exec 2>&1
if [ "$(id -u)" != "0" ]
then
        errorecho "ERROR: This script has to be run as root!"
        exit 1
fi
echo -e "\n###### Starting the Backup: ${currentDateReadable} ######\n"
echo -e "maintenance mode is being activated"
sudo docker exec -u www-data ${dockerContainerName} php /var/www/nextcloud/occ maintenance:mode --on

echo -e "\nBackup in progress"
borg create --stats \
    $borgRepository::"${currentDate}" \
        $borgBackupDirs
echo
echo -e "maintenance mode is being deactivated"
sudo docker exec -u www-data ${dockerContainerName} php /var/www/nextcloud/occ maintenance:mode --off

borg prune --progress --stats $borgRepository --keep-within=7d --keep-weekly=2 --keep-monthly=6
endTime=$(date +%s)
endDateReadable=$(date --date @"$endTime" +"%d.%m.%Y - %H:%M:%S")
duration=$((endTime-startTime))
durationSec=$((duration % 60))
durationMin=$(((duration / 60) % 60))
durationHour=$((duration / 3600))
durationReadable=$(printf "%02d hours %02d minutes %02d seconds" $durationHour $durationMin $durationSec)
echo -e "\n###### End of Backup: ${endDateReadable} (${durationReadable}) ######\n"
echo -e "backup disk usage:\n"
df -h ${backupDiscMount}

mail -s "Nextcloud backup finished" ${LOGGING_MAIL} -aFrom:${MAIL_SENDER} < "${logFile}"