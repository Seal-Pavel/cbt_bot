#!/bin/bash

set -e

SCRIPTS_DIR_NAME='scripts'
SCRIPTS_DIR_PATH=$(pwd | sed -E "s|(.*${SCRIPTS_DIR_NAME}).*|\1|")
source "$SCRIPTS_DIR_PATH/common.sh"

# Kubernetes
DEPLOY_SERVICE_NAME='bot'
# Kubernetes Paths
MAIN_PATH="./$DEPLOY_SERVICE_NAME/kubernetes"
ENV_PATH="$MAIN_PATH/.env.$DEPLOY_SERVICE_NAME"
SECRET_PATH="$MAIN_PATH/secret_$DEPLOY_SERVICE_NAME.yaml"
DEPLOYMENT_YAML_PATH="$MAIN_PATH/deployment_$DEPLOY_SERVICE_NAME.yaml"
DOCKERFILE_DIR_PATH="./$DEPLOY_SERVICE_NAME/"
# DockerHub
DEPLOY_IN_DOCKERHUB="False"
DOCKER_USERNAME="sealpavel"
# Common
BOT_NAME="cbt_bot"
TAG=$(date +"%Y%m%d-%H%M")


echo "Creating secret_$DEPLOY_SERVICE_NAME.yaml file from .env.$DEPLOY_SERVICE_NAME..."
kubectl create secret generic "env.$DEPLOY_SERVICE_NAME" --from-env-file=$ENV_PATH --dry-run=client -o yaml > $SECRET_PATH

echo "Applying secret_$DEPLOY_SERVICE_NAME.yaml..."
kubectl apply -f $SECRET_PATH || { echo "Error applying secret_$DEPLOY_SERVICE_NAME.yaml"; exit 1; }

echo "Checking if secret is created..."
kubectl get secret/env || { echo "Error checking for secret"; exit 1; }

echo "Applying deployment_$DEPLOY_SERVICE_NAME.yaml..."
kubectl apply -f $DEPLOYMENT_YAML_PATH || { echo "Error applying deployment_$DEPLOY_SERVICE_NAME.yaml"; exit 1; }

echo "Building image of a $DEPLOY_SERVICE_NAME..."
docker build -t "$BOT_NAME:$TAG" $DOCKERFILE_DIR_PATH
docker tag "$BOT_NAME:$TAG" "$BOT_NAME:latest"

echo "Restarting Pods..."
kubectl rollout restart deployment telegram-bot-deployment

echo "Waiting for the pods to be restarted..."
kubectl rollout status deployment telegram-bot-deployment || { echo "Error during pod restart"; exit 1; }

echo "Deployment for $DEPLOY_SERVICE_NAME successfully completed."

# DockerHub
if [ "$DEPLOY_IN_DOCKERHUB" = "True" ]; then
  echo "Pushing image to Docker Hub..."
  docker push $DOCKER_USERNAME/"$BOT_NAME:$TAG"

  docker tag $DOCKER_USERNAME/"$BOT_NAME:$TAG" $DOCKER_USERNAME/"$BOT_NAME:latest"
  docker push $DOCKER_USERNAME/"$BOT_NAME:latest"

  echo "Release with tag $TAG completed."
else
  echo "Skipping Docker Hub deployment as DEPLOY_IN_DOCKERHUB=$DEPLOY_IN_DOCKERHUB."
fi