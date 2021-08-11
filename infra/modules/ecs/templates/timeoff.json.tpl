[
    {
      "name": "${name}",
      "image": "${container_image}",
      "cpu": ${cpu},
      "memory": ${memory},
      "memoryReservation": ${memory},
      "environment": [
        { "name" : "ENV_VAR", "value" : "VALUE" }
      ],
      "essential": true,
      "portMappings": [
            {
              "containerPort": ${timeoff_port},
              "hostPort": ${host_port}
            }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${log_group}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "timeoff"
        }
      }
    }
]