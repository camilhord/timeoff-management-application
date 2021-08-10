variable "vpc_id" {
  type        = string
}

variable "subnet_id" {
  type        = string
}

variable "route_table_ids" {
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the object."
  type        = map
}