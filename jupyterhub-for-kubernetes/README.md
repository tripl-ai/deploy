# jupyterhub-for-kubernetes

This example uses Helm to set up [JupyterHub](https://zero-to-jupyterhub.readthedocs.io/en/stable/index.html) and install an environment which uses OAuth to authenticate users and start containers using that user's specific service account.

Each user will need a specific service account and bindings to the cloud providers' IAM permissions.