pipeline {
    agent any
    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        APP_NAME="to-do-app"
        APP_REPO_NAME="todo-app"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        AWS_REGION="eu-central-1"
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }
    stages {
        stage('Building Application') {
            steps {
                echo 'Application is building'
                sh ". ./build-image.sh"
            }
        }
       
      
        stage('Push Images to ECR Repo') {
            steps {
                echo "Pushing ${APP_NAME} App Images to ECR Repo"
                sh ". ./push-image.sh"
            }
        }
        stage('Deploy App on TODO Kubernetes Cluster'){
            steps {
                echo 'Deploying App on K8s Cluster'
                sh ". ./deploy-app.sh"
            }
        }
    }
    post {
        always {
            echo 'Deleting all local images'
            sh 'docker image prune -af'
        }
    }
}