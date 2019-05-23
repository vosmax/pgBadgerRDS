#!/usr/bin/env bash 
set -o errexit

print_log() {
  echo $(date +"%d-%m-%Y %T") $1
}

PG_LOG_FILE_NAME=rds_postgres.log
LOG_DATE=""
FILE_LIST=""

if [ -f $PG_LOG_FILE_NAME ]
then 
  rm -f $PG_LOG_FILE_NAME
fi

LOG_DATE=$1

#if date is not set, takes yesterday date
if [[ -z $LOG_DATE ]]
then 
  LOG_DATE=$(date -d "-1 days" +'%Y-%m-%d')
fi 
 
print_log "Log files for $LOG_DATE will be download from RDS instance $AWS_RDS_INSTANCE_NAME " 

FILE_LIST=$(aws rds describe-db-log-files --db-instance-identifier $AWS_RDS_INSTANCE_NAME | jq -r '.DescribeDBLogFiles[].LogFileName' | grep "$LOG_DATE")

for f in $FILE_LIST
do 
  print_log "Downloading $f log file"
  aws rds download-db-log-file-portion --db-instance-identifier $AWS_RDS_INSTANCE_NAME \
                                       --log-file-name $f \
                                       --starting-token 0 \
                                       --output text >> $PG_LOG_FILE_NAME 
done 

print_log "Run pgBadger"
pgbadger rds_postgres.log -f stderr -p "%t:%r:%u@%d:[%p]:"  -o report_$LOG_DATE.html

print_log "Save to S3://$AWS_BUCKET_NAME/"
aws s3 cp report_$LOG_DATE.html s3://$AWS_BUCKET_NAME/ && rm report_$LOG_DATE.html


