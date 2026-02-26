# mysql-backup
  - Create a backup directory
  - Add a daily cron job at 2:00 AM
  - Backup MySQL from your container
  - Keep last 7 days of backups automatically

 ## How to use:

# Make the script executable:
```bash
chmod +x setup_mysql_backup.sh
```

# Run it:
```bash
sudo ./setup_mysql_backup.sh
```
# Check that cron job is installed:
```bash
crontab -l
```
# Check backup directory:
```bash
ls -lh /home/ubuntu/mysql_backups/
```
