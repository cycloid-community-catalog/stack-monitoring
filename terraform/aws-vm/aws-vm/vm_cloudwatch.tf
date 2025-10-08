###
# Creates a cloudwatch alarm to allow to recover the EC2 prometheus instance
# if status check failed twice during 60 seconds
###

resource "aws_cloudwatch_metric_alarm" "recover-monitoring" {
  alarm_actions       = ["arn:aws:automate:${var.aws_region}:ec2:recover"]
  alarm_description   = "Recover the instance"
  alarm_name          = "recover-ec2-${local.name_prefix}"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = aws_instance.vm.id
  }

  evaluation_periods        = "2"
  insufficient_data_actions = []
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "0"
}
