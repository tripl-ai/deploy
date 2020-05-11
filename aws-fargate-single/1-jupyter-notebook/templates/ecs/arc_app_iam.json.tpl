[
  {
    "name": "${container_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${container_name}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort":${app_port},
        "hostPort":${app_port}
      },
       {
        "protocol": "tcp",
        "containerPort":4040,
        "hostPort":4040
      }
    ],
    "command": [
          "jupyter",
          "notebook",
          "--ip=0.0.0.0",
          "--no-browser",
          "--NotebookApp.password=''",
          "--NotebookApp.token=''"
     ],
     "environment": [
        {
          "name": "JAVA_OPTS",
          "value": "-Xmx6g"
        },
        {
          "name": "ETL_CONF_INPUT_LOC",
          "value": "${ecs_s3_bucket}"
        }
    ]
  }
]
