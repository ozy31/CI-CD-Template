pipeline {
    agent any
    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }
    environment {
        PATH = "${env.PATH}:/usr/local/bin"
        APP_NAME = "to-do-app"
        APP_REPO_NAME = "todo-app"
        AWS_REGION = "eu-central-1"
        AWS_ACCOUNT_ID = sh(script: 'aws sts get-caller-identity --query Account --output text', returnStdout: true).trim()
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        HELM_S3_REPO = "s3://todo-helm-charts/stable/todo/"
        NAMESPACE = "todo-dev"
    }
    stages {
        stage('Build & Test') {
            steps {
                sh './build-image.sh'
            }
        }
        stage('Push to ECR') {
            steps {
                sh './push-image.sh'
            }
        }
        stage('Deploy with Helm') {
            when { branch 'main' }
            steps {
                sh './deploy-app.sh'
            }
        }
    }
    post {
        always {
            sh 'docker image prune -af || true'
        }
    }
}
