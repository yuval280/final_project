#!/bin/bash

DATE=$(date +%Y-%m-%d_%H-%M)
DB_BACKUP="backup_$DATE.sql"
FILES_BACKUP="site-backup_$DATE.tar.gz"

echo "📦 מגבה בסיס נתונים..."
docker exec joomla-mysql sh -c 'mysqldump -u joomla -pjoomla joomla' > backups/"$DB_BACKUP"

echo "📂 מגבה קבצי אתר..."
tar -czvf backups/"$FILES_BACKUP" ./joomla_data

echo "✅ הגיבוי הסתיים: $DB_BACKUP + $FILES_BACKUP"


