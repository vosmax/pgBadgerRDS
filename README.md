# pgBadgerRDS

Container runs pgBadger for an AWS RDS instance, which generates a report that is saved in an AWS S3 bucket with the name report_\<report_date\>.html

| **Name** | **Description** | 
-------|--------------
AWS_CLI_VERSION | Version of AWS CLI which will be used
PGBADGER_VERSION | Version of pgBadger which will be used
AWS_ACCESS_KEY_ID | AWS access key
AWS_ACCESS_SECRET_KEY | AWS access secret
AWS_DEFAULT_REGION | AWS region of RDS and S3 services
AWS_RDS_INSTANCE_NAME  | Name of the AWS RDS instance whose logs are to be processed
AWS_BUCKET_NAME | Name of the AWS S3 bucket where logs are saved upon completion