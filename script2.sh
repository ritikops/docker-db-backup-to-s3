#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DATE=$(date +%Y/%m/%d)
TODAY=$(date +%Y-%m-%d)

BUCKET="test-backup-sk"
PG_CONTAINER="pg-test"
MONGO_CONTAINER="mongo-test"
MONGO_USER="root"
MONGO_PASS="root"
MONGO_AUTH_DB="admin"
PG_USER="postgres"

PG_BACKUP="/tmp/pg_backup_$TODAY.sql"
MONGO_FOLDER="/tmp/mongo_$TODAY"
MONGO_ZIP="/tmp/mongo_$TODAY.zip"

PG_S3_PATH="s3://$BUCKET/$DATE/pg_backup_$TODAY.sql"
MONGO_S3_PATH="s3://$BUCKET/$DATE/mongo_$TODAY.zip"

docker exec $PG_CONTAINER pg_dumpall -U $PG_USER > $PG_BACKUP
docker exec "$MONGO_CONTAINER" mongodump --username "$MONGO_USER" --password "$MONGO_PASS" --authenticationDatabase "$MONGO_AUTH_DB" --out /tmp/mongo_backup
mkdir -p "$MONGO_FOLDER/mongo-backup"
docker cp $MONGO_CONTAINER:/tmp/mongo_backup/. "$MONGO_FOLDER/mongo-backup"

cd /tmp || exit
zip -r "$MONGO_ZIP" "mongo_$TODAY"
cd - || exit

aws s3 cp "$PG_BACKUP" "$PG_S3_PATH"
aws s3 cp "$MONGO_ZIP" "$MONGO_S3_PATH"

rm -f $PG_BACKUP $MONGO_DUMP $MONGO_ZIP
rm -rf $MONGO_FOLDER
