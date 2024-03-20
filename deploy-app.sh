echo 'Deploying App on Kubernetes'
envsubst < k8s/todo_chart/values-template.yaml > k8s/todo_chart/values.yaml
sed -i s/HELM_VERSION/${BUILD_NUMBER}/ k8s/todo_chart/Chart.yaml
AWS_REGION=$AWS_REGION helm repo add stable-todo s3://todo-helm-charts-tr/stable/myapp/ || echo "repository name already exists"
AWS_REGION=$AWS_REGION helm repo update
helm package k8s/todo_chart
AWS_REGION=$AWS_REGION helm s3 push --force todo_chart-${BUILD_NUMBER}.tgz stable-todo
kubectl create ns todo-dev-ns || echo "namespace todo-dev-ns already exists"
kubectl delete secret regcred -n todo-dev-ns || echo "there is no regcred secret in todo-dev-ns namespace"
kubectl create secret generic regcred -n todo-dev-ns \
    --from-file=.dockerconfigjson=/var/lib/jenkins/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
AWS_REGION=$AWS_REGION helm repo update
AWS_REGION=$AWS_REGION helm upgrade --install \
    todo-app-release stable-todo/todo_chart --version ${BUILD_NUMBER} \
    --namespace todo-dev-ns