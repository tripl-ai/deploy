# Deploy

## Kubernetes

These examples show how to run against a Kubernetes cluster:

- [spark-on-k8s-operator](https://github.com/tripl-ai/deploy/tree/master/spark-on-k8s-operator) for running on Kubernetes with the [spark-on-k8s-operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).
- [kubernetes-argo](https://github.com/tripl-ai/deploy/tree/master/kubernetes-argo) for running on Kubernetes and deploy jobs using [Argo](https://argoproj.github.io/) workflows. Argo allows the definition of dependencies between jobs which can be useful for complex workflows or jobs which require different service-account permissions to execute.
- [jupyterhub-for-kubernetes](https://github.com/tripl-ai/deploy/tree/master/jupyterhub-for-kubernetes) for how to run JupyterHub on Kubernetes to allow end-users to start their own JupyterLab instances to build Arc jobs.


## AWS

These are example [Terraform](https://www.terraform.io/) scripts to demonstrate how to execute Arc against a remote cluster.

- [aws-single-master](https://github.com/tripl-ai/deploy/tree/master/aws-single-master) for a single instance.
- [aws-cluster](https://github.com/tripl-ai/deploy/tree/master/aws-cluster) for a multi-instance cluster.
- [aws-fargate-single](https://github.com/tripl-ai/deploy/tree/master/aws-fargate-single) for a serverless option.

These both assume the `default` security group has access to SSH to your EC2 instances. There are sample `user-data-*` scripts in the `./templates` which have commands for mounting the local SSD of certain instance types to `/data`. If used the following `docker run` commands should be used:

```bash
-v /data/local:/local \
-e "SPARK_LOCAL_DIRS=/local" \
-e "SPARK_WORKER_DIR=/local" \
```
