
# Dashboard 


resource "aws_cloudwatch_dashboard" "reliability" {
  dashboard_name = "infra-reliability-lab"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title  = "ASG - Average CPU Utilization"
          region = "eu-west-3"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/AutoScaling", "ASGAverageCPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.app.name]
          ]
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title  = "ASG - Group InService Instances"
          region = "eu-west-3"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", aws_autoscaling_group.app.name]
          ]
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title  = "ALB - TargetResponseTime"
          region = "eu-west-3"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title  = "ALB - HTTP 5XX"
          region = "eu-west-3"
          period = 60
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", aws_lb.app.arn_suffix],
            [".", "HTTPCode_Target_5XX_Count", ".", "."]
          ]
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 12,
        width  = 12,
        height = 6,
        properties = {
          title  = "ALB - Request Count"
          region = "eu-west-3"
          period = 60
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
        }
      }
    ]
  })
}


# Alarms

# Alarms CPU (ASG)

resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "infra-reliability-lab-asg-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ASGAverageCPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "ASG average CPU is high (possible saturation)."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}


# Alarms errors 5XX target

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "infra-reliability-lab-alb-target-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Targets are returning 5XX errors."

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "slo_violation" {
  alarm_name          = "infra-reliability-slo-breach"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 20
  alarm_description   = "SLO violation: error rate too high"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
  }
}

