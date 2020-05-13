# aws-fargate-single

The Terraform deployment helps you to spin up a single node compute resource via AWS Fargate in Amazon ECS, which will create a long running ECS service for [ARC Jupyter Notebook](./1-jupyter-notebook/README.md) and a transient ECS task for [ARC ETL job](./2-arc-etl/README.md).


## Usage

### 1. Download the project
```
$ git clone git@github.com:tripl-ai/deploy.git
$ cd deploy/aws-fargate-single
```

### 2. Setup base infrastructure [Optional]

```
$ cd 0-base
```
To store your deployment [state remotely](https://www.terraform.io/docs/state/remote.html), follow the [instruction](./0-base/README.md) to create a new S3 bucket, then note it down for the later use. 

If you prefer to store the state on your local computer, please skip this step.


### 3. Deploy Jupyter Notebook
```
$ cd 1-jupyter-notebook
```
Follow the [instruction](./1-jupyter-notebook/README.md) to spin up an ARC jupyter-notebook instance in AWS Fargate
### 4. Setup Job Trigger
```
$ cd 2-arc-etl
```
Make sure you have deployed jupyter-notebook first, then follow the [instruction](./2-arc-etl/README.md) to setup an automated trigger to execute ARC job in AWS Fargate. The job will be fired up, as soon as you drop off an jupyter notebook file to the location.

NOTE: If you need to deploy `1-jupyter-notebook` again, make sure followed `2-arc-etl` to refresh your job trigger.

### 5. Clean Up

This is really important because if you leave stuff running in your account, it will continue to generate charges. Make sure you clean them up by the following command in order:

```
# clean up job trigger first
$ cd 2-arc-etl
$ terraform destroy

# clean up essential infrastructure
cd ../1-jupyter-noetbook
terraform destroy

# clean up base infrastructure [OPTIONAL]
cd ../0-base
terraform destroy

```

