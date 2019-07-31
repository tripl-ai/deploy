These are example [Terraform](https://www.terraform.io/) scripts to demonstrate how to execute Arc against a remote cluster.

For AWS:

- [aws-single-master](https://github.com/tripl-ai/deploy/tree/master/aws-single-master) for a single instance. 
- [aws-cluster](https://github.com/tripl-ai/deploy/tree/master/aws-cluster) for a multi-instance cluster.

There are sample `user-data-*` scripts in the `./templates` which have commands for mounting the local SSD of certain instance types to `/data`. If used the following `docker run` commands should be used:

```bash
-v /data/local:/local \
-e "SPARK_LOCAL_DIRS=/local" \
-e "SPARK_WORKER_DIR=/local" \
```