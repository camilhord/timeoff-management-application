resource "aws_cloudwatch_log_group" "loggroup" {
  name = var.name_prefix
  tags = var.tags
}