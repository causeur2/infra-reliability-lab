resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/infra-reliability-lab/app"
  retention_in_days = 14

  tags = {
    Project = "infra-reliability-lab"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_cloudwatch_log_metric_filter" "app_errors" {
  name           = "infra-reliability-app-errors"
  log_group_name = aws_cloudwatch_log_group.app_logs.name
  pattern        = "\"ERROR\""

  metric_transformation {
    name      = "AppErrorCount"
    namespace = "InfraReliabilityLab"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "app_error_alarm" {
  alarm_name          = "infra-reliability-app-error-spike"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "AppErrorCount"
  namespace           = "InfraReliabilityLab"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Application error spike detected."

  treat_missing_data = "notBreaching"
}
