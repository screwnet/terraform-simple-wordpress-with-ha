WordPress Hosting on AWS with HA

The deployment includes the following AWS components:
1. VPC
2. EC2
3. ALB
4. CloudFront
5. RDS
6. R53

The DNS is managed by R53 service and records are updated there.
ALB is used for SSL termination and directing the traffic to the Target Group which has EC2 instances under ASG registered to receive and process traffic.
Wordpress is installed to a master EC2 instance with files stored in EFS for HA access from ASG registered EC2 instances.
When the Wordpress requires database access, the connection is made from the instance to RDS instance.
S3 buckets are created for logging and storing CloudFront static files, separately.

More to work:
Split into multiple 
