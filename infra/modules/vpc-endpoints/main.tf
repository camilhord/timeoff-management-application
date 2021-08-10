data "aws_vpc_endpoint_service" "s3" {
  service      = "s3"
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids
}

data "aws_vpc_endpoint_service" "logs" {
  service      = "logs"
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.logs.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [var.subnet_id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

data "aws_vpc_endpoint_service" "ecr_dkr" {
  service      = "ecr.dkr"
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.ecr_dkr.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [var.subnet_id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

data "aws_vpc_endpoint_service" "ecr_api" {
  service      = "ecr.api"
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.ecr_api.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [var.subnet_id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

data "aws_vpc_endpoint_service" "execute_api" {
  service      = "execute-api"
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "execute_api" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.execute_api.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [var.subnet_id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "sg_vpc_endpoint"
  description = "sg_vpc_endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

