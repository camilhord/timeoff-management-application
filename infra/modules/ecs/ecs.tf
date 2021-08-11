resource "aws_ecs_cluster" "ecs_cluster" {
  name  = "${var.name_prefix}-cluster"
  tags  = var.tags
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "${var.name_prefix}-service"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecstask.arn
  desired_count                      = 1
  force_new_deployment               = true
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = var.timeoff_subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "${var.name_prefix}-container"
    container_port   = var.timeoff_port
  }

}

data "template_file" container_def {
  template = file("${path.module}/templates/timeoff.json.tpl")

  vars = {
    name     = "${var.name_prefix}-container"
    timeoff_port    = var.timeoff_port
    host_port       = var.host_port
    container_image = "${aws_ecr_repository.timeoff.repository_url}:latest"
    region          = var.region
    account_id      = var.account_id
    log_group       = aws_cloudwatch_log_group.loggroup.name
    memory          = var.timeoff_memory
    cpu             = var.timeoff_cpu
  }
}


resource "aws_ecs_task_definition" "ecstask" {
  family                   = "${var.name_prefix}-task-definition"
  container_definitions    = data.template_file.container_def.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.timeoff_cpu
  memory                   = var.timeoff_memory
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  tags = {}
}

resource "aws_security_group" "ecs_sg" {
  name_prefix        = "${var.name_prefix}_sg_task_def"
  description = "sg_taskDefinition"
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
    name_prefix = "allow_tls"
  }
}