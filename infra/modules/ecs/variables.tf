variable "name_prefix" {
  description = "Name to use for all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the ECS sg will get created"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the object."
  type        = map
}

variable timeoff_cpu {
  type    = number
  default = 2048
}

variable timeoff_memory {
  type    = number
  default = 4096
}

variable alb_subnet_ids {
  type        = list(string)
  description = "A list of subnets for the Application Load Balancer"
  default     = null
}

variable timeoff_subnet_ids {
  type        = list(string)
  description = "A list of subnets for the timeoff fargate service"
  default     = null
}

variable alb_type_internal {
  type    = bool
  default = false
  // default = true
}

variable alb_enable_access_logs {
  type    = bool
  default = false
}

variable alb_access_logs_bucket_name {
  type    = string
  default = null
}

variable alb_access_logs_s3_prefix {
  type    = string
  default = null
}

variable alb_ingress_allow_cidrs {
  type        = list(string)
  description = "A list of cidrs to allow inbound into timeoff"
  default     = null
}

variable alb_acm_certificate_arn {
  type        = string
  description = "The ACM certificate ARN to use for the alb"
}

variable host_port {
  type    = number
  default = 8080
}

variable timeoff_port {
  type    = number
  default = 8080
}

variable region {
  type    = string
}

variable account_id {
  type    = string
}