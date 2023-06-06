resource "aws_launch_template" "this" {
  name     = var.app_tag
  image_id = "ami-0459250212a773e1a"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = data.aws_key_pair.main.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.allow_all_local.id,
      aws_security_group.allow_all_ssh.id,
      aws_security_group.allow_all_http.id
    ]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.app_tag
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = var.app_tag
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.public_3.id,
  ]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.http80.arn]

  tag {
    key                 = "Name"
    value               = var.app_tag
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "up" {
  name                   = format("%s_scale_up", var.app_tag)
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "up" {
  alarm_name          = format("%s_cpu_avg_up_80", var.app_tag)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.up.arn]
}

resource "aws_autoscaling_policy" "down" {
  name                   = format("%s_scale_down", var.app_tag)
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "down" {
  alarm_name          = format("%s_cpu_avg_down_20", var.app_tag)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.down.arn]
}
