terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      version = "3.45.0"
      source = "hashicorp/aws"
    } 
  }
}

provider "aws" {
  region = local.region
}