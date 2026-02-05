pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Run Tests') {
      steps {
        sh '''
        python3 -m venv venv
        . venv/bin/activate
        pip3 install --upgrade pip
        pip3 install -r requirements.txt
        pytest
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t fastapi-cicd-app .'
      }
    }
  }
}

