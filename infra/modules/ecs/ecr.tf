resource "aws_ecr_repository" "timeoff" {
  name  = "${var.name_prefix}-ecr"
  tags  = var.tags
}