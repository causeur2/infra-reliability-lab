resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.app.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    # Ajuste si besoin : 50-60 est un bon range pour un lab SRE
    target_value = 55.0

    # Pour éviter le yo-yo
    disable_scale_in = false
  }

  # Cooldowns “propres”
  estimated_instance_warmup = 120
}
