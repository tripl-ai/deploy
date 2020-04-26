# Kubernetes

## Tools needed

You need a way of interacting with the Kubernetes cluster so install the `kubectl` cli:

```bash
brew install kubectl
```

## Start a local cluster

This example uses [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker) to run a local Kubernetes cluster to demonstrate how to execute Arc within Kubernetes.

First install the `kind` cli:

```bash
brew install kind
```

Create the `kind` cluster:

```bash
kind create cluster --config=kind/kind.config
```

Ensure you can connect to the cluster:

```bash
kubectl cluster-info
```

You can load a local docker image into `kind` like this so you could easily load a custom version of the Arc image. If you don't do this Kubernetes will try to download the image again from the docker registry on each machine which is disallowed:

```bash
kind load docker-image triplai/arc:arc_2.10.2_spark_2.4.5_scala_2.12_hadoop_2.9.2_1.0.0
```

## Set Up Argo

To interact with Argo you need to install the `argo` cli:

```bash
brew install argoproj/tap/argo
```

Create a `namespace` for Argo and install it. The only difference between this Argo `install.yaml` and the public ones is to change the [containerRuntimeExecutor](https://github.com/argoproj/argo/blob/master/docs/workflow-executors.md) mode to `pns` instead of default `docker` so that it executes on non-docker container engines like [containerd](https://containerd.io/) which is included with [kind](https://kind.sigs.k8s.io/).

```bash
kubectl create namespace argo
kubectl apply -n argo -f argo/install.yaml
```

Additionally create service account permissions so the containers can interact with the Kubernetes API. These permissions give *administrator* rights so do not use in production.

```bash
kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=default:default
kubectl create clusterrolebinding default-cluster-admin --clusterrole=cluster-admin --user system:serviceaccount:default:default
```

Test that jobs can be sumitted and reach successful conclusion:

```bash
argo submit --watch argo/hello-world.yaml
```

To start the Argo UI accessible via [http://localhost:2746](http://localhost:2746):

```bash
argo server
```

## Submit an Arc job

First add the Arc workflow templates which define how to execute Arc within Kubernetes. This file should not need to be modified and can be invoked by the execution jobs.

```bash
argo template create arc/workflow-templates/arc.yaml
```

Then a test job can be submitted which invokes the workflow-template:

```bash
argo submit arc/nyctaxi.yaml
```

To modify the job it should only be done by adding or modifying steps at the `nyctaxi` level not the `workflow-templates`.

## Clean up

Delete the cluster:

```bash
kind delete cluster
```
