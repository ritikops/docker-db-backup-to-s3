
---

````markdown
#  Docker DB Backup to S3

A lightweight and automated Bash script to back up PostgreSQL and MongoDB databases running in Docker containers, compress them, and upload to AWS S3 — organized by date.

---

##  Features

-  Backs up **PostgreSQL** using `pg_dumpall`
-  Backs up **MongoDB** using `mongodump`
-  Compresses MongoDB backups into `.zip`
-  Organizes backups into **date-based folders**
-  Uploads backups to **Amazon S3**
-  Cleans up temporary files after upload
-  Designed for **automated daily backups** via cron

---

##  Requirements

- [Docker](https://www.docker.com/)
- Zip
- Bash shell

---

##  Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/your-username/docker-db-backup-to-s3.git
cd docker-db-backup-to-s3
````

### 2. Edit the script

Open `backup_to_s3.sh` and update the following variables to match your setup:

```bash
BUCKET="your-s3-bucket-name"
PG_CONTAINER="your-postgres-container-name"
MONGO_CONTAINER="your-mongo-container-name"
PG_USER="your-postgres-username"
```

### 3. Make the script executable

```bash
chmod +x backup_to_s3.sh
```

### 4. Schedule the script using `cron`

Open the crontab editor:

```bash
crontab -e
```

Add the following line to run the backup **daily at midnight**:

```bash
0 0 * * * /path/to/backup_to_s3.sh >> /path/to/backup.log 2>&1
```

>  *Replace `/path/to/` with the actual full path to the script and log file.*

---

##  Example S3 Output

Your backup files will be structured like this in your S3 bucket:

```
s3://your-bucket/2025/06/27/pg_backup_2025-06-27.sql
s3://your-bucket/2025/06/27/mongo_2025-06-27.zip
```

---
