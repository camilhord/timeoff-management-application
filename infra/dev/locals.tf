data "aws_caller_identity" "current" {}

locals {
  environment      = "timeoff"
  account_id       = data.aws_caller_identity.current.account_id
  region           = "us-east-1"
  s3_bucket_name   = "do-automation-packer-templates"
  tags = {
    Environment = "local.environment"
  }
}
