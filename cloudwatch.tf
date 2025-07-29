#######################################
# CloudWatch Log Group for EC2 Logs
#######################################
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/ec2/webapp"
  retention_in_days = 7

  tags = {
    Name = "webapp-log-group"
  }
}

#######################################
# IAM Role for VPC Flow Logs
#######################################
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      Resource = "*"
    }]
  })
}

#######################################
# VPC Flow Logs
#######################################
resource "aws_flow_log" "vpc_flow_log" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.ec2_logs.arn  # <-- ARN, not name
  iam_role_arn         = aws_iam_role.vpc_flow_log_role.arn
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"

  tags = { Name = "vpc-flow-logs" }
}

# Optional: Alarm for ASG avg CPU > 70%
resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "asg-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Average CPU across ASG is too high"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}