resource "aws_flow_log" "wp-vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpcflowlogRole.arn
  log_destination = aws_cloudwatch_log_group.wp_flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.wordpress-vpc.id
}

resource "aws_cloudwatch_log_group" "wp_flow_log_group" {
  name = "wp_flow_log_group"
}

resource "aws_iam_role" "vpcflowlogRole" {
  name               = "wp-vpcflowlogRole"
  description        = "Provides IAM role for VPC flow-log"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpcflowlogRolePolicy" {
  name   = "vpcflowlogRolePolicy"
  role   = aws_iam_role.vpcflowlogRole.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":
      [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
