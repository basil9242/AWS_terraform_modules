# Log Streams
resource "aws_cloudwatch_log_stream" "log_streams" {
  count          = var.create_log_streams ? length(var.log_streams) : 0
  name           = var.log_streams[count.index]
  log_group_name = aws_cloudwatch_log_group.cloudwatch_logs_group.name

  depends_on = [aws_cloudwatch_log_group.cloudwatch_logs_group]
}