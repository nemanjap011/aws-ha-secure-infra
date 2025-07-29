#######################################
# Auto Scaling Group (Web Tier)
#######################################
resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  vpc_zone_identifier       = aws_subnet.private[*].id
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 4
  health_check_type         = "ELB"
  health_check_grace_period = 60
  force_delete              = true

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#######################################
# Auto Scaling Policy (Optional)
#######################################
resource "aws_autoscaling_policy" "cpu_scale_out" {
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}