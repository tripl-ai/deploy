#!/bin/bash
#set -x

build_deploy_docker_image(){
  aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REPO}

  docker pull ${JUPYTER_IMAGE}
  docker pull ${ARC_IMAGE}

  echo "** finished pulling docker images***"
  docker tag  ${JUPYTER_IMAGE} ${ECR_REPO}:arc-jupyter
  docker tag  ${ARC_IMAGE} ${ECR_REPO}:arc
  
  echo "**create docker image in ECR ***"
  docker push ${ECR_REPO}:arc-jupyter
  docker push ${ECR_REPO}:arc
}

deploy(){
   # build and push docker image to azure container registry
   build_deploy_docker_image
}

deploy