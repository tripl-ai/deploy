# kubernetes-argo

This example shows how to running on Kubernetes and deploy jobs using [Argo](https://argoproj.github.io/) workflows.

## Create the templates

First add the Arc workflow templates which defines how to execute Arc within Kubernetes.

```bash
argo template delete arc
argo template create arc/workflow-templates/arc.yaml
```

## Run the job

Then a test job can be submitted which invokes the workflow-template:

```bash
argo submit arc/nyctaxi.yaml
```
