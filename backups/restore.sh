#!/bin/bash

# משתנים - תוכל לשנות כאן אם צריך
MYSQL_CONTAINER="joomla-mysql"
DB_NAME="joomla"
DB_USER="joomla"
DB_PASS="joomla"

BACKUP_SQL="backup_2025-08-01_13-46.sql"            # קובץ גיבוי בסיס הנתונים שלך (שים כאן את השם המדויק)
BACKUP_SITE="site-backup_2025-08-01_13-46.tar.gz"  # קובץ גיבוי קבצי האתר (שים כאן את השם המדויק)

# 1. עצור ומחק קונטיינרים ו-volumes
echo "🧹 מוריד קונטיינרים ו-volumes..."
docker compose down -v

# 2. מחק ושחזר קבצי האתר
echo "📂 משחזר קבצי האתר..."
rm -rf ./joomla_data
mkdir -p ./joomla_data
tar -xvzf "$BACKUP_SITE" -C ./joomla_data

# 3. הפעל את מסד הנתונים בלבד
echo "🛢️ מפעיל את MySQL..."
docker compose up -d mysql

# מחכה 10 שניות ל-MySQL לעלות
echo "⏳ ממתין 10 שניות ש-MySQL יעלה..."
sleep 10

# 4. מעתיק את קובץ הגיבוי לתוך קונטיינר MySQL
echo "📥 מעתיק את קובץ הגיבוי לקונטיינר..."
docker cp "$BACKUP_SQL" "$MYSQL_CONTAINER":/backup.sql

# 5. משחזר את בסיס הנתונים
echo "🗄️ משחזר את בסיס הנתונים..."
docker exec -i "$MYSQL_CONTAINER" sh -c "mysql -u $DB_USER -p$DB_PASS $DB_NAME < /backup.sql"

# 6. מפעיל את כל השירותים
echo "🚀 מפעיל את כל השירותים..."
docker compose up -d
