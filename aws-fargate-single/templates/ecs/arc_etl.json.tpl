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
          "name": "ETL_CONF_TAGS",
          "value": "project=ARCdemo cost_center=123456 owner=meloyang"
        },
        {
          "name": "ETL_CONF_URI",
          "value": "s3a://${ecs_s3_bucket}/arcjupyter/job/IMDB_batch_demo_final.json"
        }
    ],
    "secrets": [
        {
            "name": "ETL_CONF_S3A_ACCESS_KEY",
            "valueFrom": "${access_key_arn}"       
        },
        {
            "name": "ETL_CONF_S3A_SECRET_KEY",
            "valueFrom": "${access_secret_arn}"    
        }
    ]
  }
]
