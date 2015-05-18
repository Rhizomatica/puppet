#!/bin/bash

#Where the SQLite file is located
DATABASE_FILE=/var/lib/osmocom/hlr.sqlite3

#Name of the database backup
DATABASE_NAME=hlr

# This dir will be created if it doesn't exist.
BACKUP_DIR=/var/rhizo_backups/sqlite/

# Which day to take the weekly backup from (1-7 = Monday-Sunday)
DAY_OF_WEEK_TO_KEEP=6

# Number of days to keep daily backups
DAYS_TO_KEEP=7

# How many weeks to keep weekly backups
WEEKS_TO_KEEP=5

function perform_backups()
{
    SUFFIX=$1
    FINAL_BACKUP_DIR=$BACKUP_DIR"`date +\%Y-\%m-\%d`$SUFFIX/"

    echo "Making backup directory in $FINAL_BACKUP_DIR"

    if ! mkdir -p $FINAL_BACKUP_DIR; then
        echo "Cannot create backup directory in $FINAL_BACKUP_DIR. Go and fix it!" 1>&2
        exit 1;
    fi;


    ###########################
    ###### FULL BACKUPS #######
    ###########################

    echo -e "\n\nPerforming full backup"
    echo -e "--------------------------------------------\n"

    echo "Plain backup of $DATABASE_FILE"

    if ! sqlite3 "$DATABASE_FILE" ".dump" | gzip > $FINAL_BACKUP_DIR"$DATABASE_NAME".sql.gz.in_progress; then
        echo "[!!ERROR!!] Failed to produce plain backup database $DATABASE_FILE" 1>&2
    else
        mv $FINAL_BACKUP_DIR"$DATABASE_NAME".sql.gz.in_progress $FINAL_BACKUP_DIR"$DATABASE_NAME".sql.gz
    fi

    echo -e "\nDatabase backup complete!"
}

# MONTHLY BACKUPS

DAY_OF_MONTH=`date +%d`

if [ $DAY_OF_MONTH -eq 1 ];
then
    # Delete all expired monthly directories
    find $BACKUP_DIR -maxdepth 1 -name "*-monthly" -exec rm -rf '{}' ';'

    perform_backups "-monthly"

    exit 0;
fi

# WEEKLY BACKUPS

DAY_OF_WEEK=`date +%u` #1-7 (Monday-Sunday)
EXPIRED_DAYS=`expr $((($WEEKS_TO_KEEP * 7) + 1))`

if [ $DAY_OF_WEEK = $DAY_OF_WEEK_TO_KEEP ];
then
    # Delete all expired weekly directories
    find $BACKUP_DIR -maxdepth 1 -mtime +$EXPIRED_DAYS -name "*-weekly" -exec rm -rf '{}' ';'

    perform_backups "-weekly"

    exit 0;
fi

# DAILY BACKUPS

# Delete daily backups 7 days old or more
find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*-daily" -exec rm -rf '{}' ';'

perform_backups "-daily"

