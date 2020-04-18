# aws-fargate-single

The Terraform deployment helps you to spin up a single node compute resource via AWS Fargate in Amazon ECS, which will create a long running ECS service for [ARC Jupyter Notebook](/jupyter-noteook/README.md) and a transient ECS task for [ARC job](/arc-etl/README.md).


## Steps to deploy

### 1. Download the project
```
$ git clone git@github.com:tripl-ai/deploy.git
$ cd deploy/aws-fargate-single
```

### 2. Setup base infrastructure [Optional]
To store your deployment state remotely, create an s3 bucket by following the instruction in the [base module](\base\README.md), then note down your new s3 bucket name. If you want to store the state on your local computer, please skip this step.

```
$ cd base
```

### 3. Deploy jupyter-notebook
```
$ cd jupyter-notebook
```
Follow the [instruction](/jupyter-noetbook/README.md) to spin up an ARC jupyter-notebook instance in AWS Fargate
### 4. Deploy arc-etl
```
$ cd arc-etl
```
Make sure you have deployed jupyter-notebook first, then follow the [instruction](/arc-etl/README.md) to setup an automated trigger to execute an ARC job in AWS Fargate



