#!/usr/bin/env sh
set -eu
echo "Deploying ${APP_NAME} build ${BUILD_NUMBER} to Kubernetes"

# Render values for this build and package the chart with the build number as version
envsubst < k8s/todo_chart/values-template.yaml > k8s/todo_chart/values-build.yaml
helm package k8s/todo_chart --version "0.1.${BUILD_NUMBER}" --app-version "${BUILD_NUMBER}"

# Publish the chart to the S3-backed Helm repository (helm-s3 plugin)
helm repo add stable-todo "${HELM_S3_REPO}" 2>/dev/null || true
helm s3 push --force "todo_chart-0.1.${BUILD_NUMBER}.tgz" stable-todo
helm repo update

kubectl get ns "${NAMESPACE}" >/dev/null 2>&1 || kubectl create ns "${NAMESPACE}"

# Upgrade (or install) and wait until the rollout is healthy; roll back automatically on failure
helm upgrade --install todo-app-release stable-todo/todo_chart \
  --version "0.1.${BUILD_NUMBER}" \
  --namespace "${NAMESPACE}" \
  -f k8s/todo_chart/values-build.yaml \
  --atomic --wait --timeout 5m
