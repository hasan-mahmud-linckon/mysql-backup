#!/bin/bash
# -----------------------------------------------
# MySQL Docker Backup Setup with 7-day Retention
# -----------------------------------------------

# --------- CONFIGURATION ---------
CONTAINER_NAME="red_business_mysql_container"
MYSQL_USER="root"
MYSQL_PASSWORD="<root_password>"
BACKUP_DIR="/home/ubuntu/mysql_backups"
CRON_TIME="0 2 * * *"   # 2:00 AM daily
RETENTION_DAYS=7
# ---------------------------------

# 1️⃣ Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# 2️⃣ Add cron job
CRON_CMD="docker exec $CONTAINER_NAME mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD --all-databases | gzip > $BACKUP_DIR/mysql_backup_\$(date +\%F).sql.gz && find $BACKUP_DIR/ -type f -name '*.sql.gz' -mtime +$RETENTION_DAYS -delete"

# Check if cron job already exists
crontab -l 2>/dev/null | grep -F "$CRON_CMD" >/dev/null
if [ $? -ne 0 ]; then
    (crontab -l 2>/dev/null; echo "$CRON_TIME $CRON_CMD") | crontab -
    echo "✅ Cron job added successfully!"
else
    echo "⚠️ Cron job already exists, skipping."
fi

# 3️⃣ Test backup immediately
echo "🔹 Running test backup..."
docker exec $CONTAINER_NAME mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD --all-databases | gzip > $BACKUP_DIR/mysql_backup_test_$(date +%F_%H-%M).sql.gz

echo "✅ Setup complete. Backup directory: $BACKUP_DIR"
echo "📂 Test backup created as mysql_backup_test_$(date +%F_%H-%M).sql.gz"
echo "📅 Cron will run daily at 2:00 AM and keep last $RETENTION_DAYS days of backups."
