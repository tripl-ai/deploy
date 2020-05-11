[
  {
    "name": "${arc_container_name}",
    "image": "${arc_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${arc_container_name}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "${arc_container_name}"
        }
    },
    "portMappings": [
       {
        "protocol": "tcp",
        "containerPort":4040,
        "hostPort":4040
      }
    ],
     "command": [
        "bin/spark-submit",
        "--master",
        "local[*]",
        "--conf",
        "spark.sql.streaming.checkpointLocation=demo",
        "--conf",
        "spark.authenticate=true",
        "--conf",
        "spark.authenticate.secret=$(openssl rand -hex 64)",
        "--conf",
        "spark.io.encryption.enabled=true",
        "--conf",
        "spark.network.crypto.enabled=true",
        "--class",
        "ai.tripl.arc.ARC",
        "/opt/spark/jars/arc.jar"
     ],
     "environment": [
        {
          "name": "ETL_CONF_ENV",
          "value": "test"
        },
        {
          "name": "ETL_CONF_JOB_NAME",
          "value": "endpoint3"
        },
        {
          "name": "ETL_CONF_STREAMING",
          "value": "false"
        },
        {
          "name": "ETL_CONF_INPUT_LOC",
          "value": "s3a://${ecs_s3_bucket}"
        },
        {
          "name": "ETL_CONF_TAGS",
          "value": "project=ARCdemo cost_center=123456 owner=meloyang"
        },
        {
          "name": "ETL_CONF_URI",
          "value": "s3a://blahblah.json"
        },
        {
          "name": "ETL_CONF_INPUT_LOC",
          "value": "${ecs_s3_bucket}"
        }
    ]
  }
]
