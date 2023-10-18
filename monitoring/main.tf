resource "aws_cloudwatch_metric_alarm" "http-requests" {
  alarm_name                = "app-http-requests"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "RequestCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 10
  alarm_description         = "This metric monitors elb http requests"
  dimensions = {
        LoadBalancer = aws_lb.alb.arn_suffix
      }
}