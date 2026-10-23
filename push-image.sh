#!/usr/bin/env sh
set -eu
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"
docker tag "${APP_REPO_NAME}:${BUILD_NUMBER}" "${ECR_REGISTRY}/${APP_REPO_NAME}:${BUILD_NUMBER}"
docker push "${ECR_REGISTRY}/${APP_REPO_NAME}:${BUILD_NUMBER}"
