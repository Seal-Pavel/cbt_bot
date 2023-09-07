#!/bin/bash

set -e

source .env.common

TAG=$(date +"%Y%m%d-%H%M")

echo "Building image..."
docker build -t "$BOT_NAME:$TAG" .
docker tag "$BOT_NAME:$TAG" "$BOT_NAME:latest"

echo "Restarting Pods..."
kubectl rollout restart deployment telegram-bot-deployment

echo "Waiting for the pods to be restarted..."
kubectl rollout status deployment telegram-bot-deployment || { echo "Error during pod restart"; exit 1; }

echo "Deployment successfully completed."

# # DockerHub
#DOCKER_USERNAME="sealpavel"
#echo "Building image..."
#docker build -t $DOCKER_USERNAME/"$BOT_NAME:$TAG" .
#
#echo "Pushing image to Docker Hub..."
#docker push $DOCKER_USERNAME/"$BOT_NAME:$TAG"
#
#docker tag $DOCKER_USERNAME/"$BOT_NAME:$TAG" $DOCKER_USERNAME/"$BOT_NAME:latest"
#docker push $DOCKER_USERNAME/"$BOT_NAME:latest"
#
#echo "Release with tag $TAG completed."
