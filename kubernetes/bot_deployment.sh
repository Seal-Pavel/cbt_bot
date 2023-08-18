#!/bin/bash

set -e

echo "Creating secret.yaml file from .env..."
kubectl create secret generic env --from-env-file=../.env --dry-run=client -o yaml > secret.yaml

echo "Applying secret.yaml..."
kubectl apply -f secret.yaml || { echo "Error applying secret.yaml"; exit 1; }

echo "Checking if secret is created..."
kubectl get secret/env || { echo "Error checking for secret"; exit 1; }

echo "Applying bot_deployment.yaml..."
kubectl apply -f bot_deployment.yaml || { echo "Error applying bot_deployment.yaml"; exit 1; }

echo "Restarting Pods..."
kubectl rollout restart deployment telegram-bot-deployment

echo "Waiting for the pods to be restarted..."
kubectl rollout status deployment telegram-bot-deployment || { echo "Error during pod restart"; exit 1; }

echo "Deployment successfully completed."
