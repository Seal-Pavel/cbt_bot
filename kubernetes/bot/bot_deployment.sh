#!/bin/bash

set -e

DEPLOY_SERVICE_NAME='bot'

echo "Creating secret_$DEPLOY_SERVICE_NAME.yaml file from .env.$DEPLOY_SERVICE_NAME..."
kubectl create secret generic env --from-env-file=../../$DEPLOY_SERVICE_NAME/.env.$DEPLOY_SERVICE_NAME --dry-run=client -o yaml > secret_$DEPLOY_SERVICE_NAME.yaml

echo "Applying secret_$DEPLOY_SERVICE_NAME.yaml..."
kubectl apply -f secret_$DEPLOY_SERVICE_NAME.yaml || { echo "Error applying secret_$DEPLOY_SERVICE_NAME.yaml"; exit 1; }

echo "Checking if secret is created..."
kubectl get secret/env || { echo "Error checking for secret"; exit 1; }

echo "Applying deployment_$DEPLOY_SERVICE_NAME.yaml..."
kubectl apply -f deployment_$DEPLOY_SERVICE_NAME.yaml || { echo "Error applying deployment_$DEPLOY_SERVICE_NAME.yaml"; exit 1; }

echo "Restarting Pods..."
kubectl rollout restart deployment telegram-bot-deployment

echo "Waiting for the pods to be restarted..."
kubectl rollout status deployment telegram-bot-deployment || { echo "Error during pod restart"; exit 1; }

echo "Deployment for $DEPLOY_SERVICE_NAME successfully completed."
