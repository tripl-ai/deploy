kubectl create namespace jupyterhub
helm upgrade --install jupyterhub jupyterhub-0.11.1.tgz --namespace jupyterhub --values config.yaml --debug --atomic