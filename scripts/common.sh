#!/bin/bash

set -e

PROJECT_NAME="cbt_bot"
PROJECT_DIR=$(pwd | sed -E "s|(.*${PROJECT_NAME}).*|\1|")

OS=$(uname)
if [ "$OS" = "Darwin" ]; then
  # macOS
  sed -i '' "s|^PROJECT_NAME=.*|PROJECT_NAME=$PROJECT_NAME|" $PROJECT_DIR/.env.common
  sed -i '' "s|^PROJECT_DIR=.*|PROJECT_DIR=$PROJECT_DIR|" $PROJECT_DIR/.env.common
else
  # Linux
  sed -i "s|^PROJECT_NAME=.*|PROJECT_NAME=$PROJECT_NAME|" $PROJECT_DIR/.env.common
  sed -i "s|^PROJECT_DIR=.*|PROJECT_DIR=$PROJECT_DIR|" $PROJECT_DIR/.env.common
fi

echo "Go to the root directory($PROJECT_DIR) of the project..."
cd $PROJECT_DIR

source .env.common