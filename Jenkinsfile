pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "552993617227"
        ECR_REPO = "fastapi-cicd-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_URI = "552993617227.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies & Run Tests') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                pytest tests/
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                docker tag ${ECR_REPO}:${IMAGE_TAG} \
                ${ECR_URI}/${ECR_REPO}:${IMAGE_TAG}
                docker tag ${ECR_REPO}:${IMAGE_TAG} \
                ${ECR_URI}/${ECR_REPO}:latest
                '''
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin \
                ${ECR_URI}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker push ${ECR_URI}/${ECR_REPO}:${IMAGE_TAG}
                docker push ${ECR_URI}/${ECR_REPO}:latest
                '''
            }
        }
    }
}

