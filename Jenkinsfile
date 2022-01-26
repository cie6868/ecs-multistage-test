#!/usr/bin/env groovy

pipeline {

    agent any

    options {
        timeout(time: 15, unit: 'MINUTES')
        timestamps()
    }

    tools {
        dockerTool 'docker-latest'
    }

    environment {
        APP_NAME = 'ECS Test Deployment'
        IMAGE_NAME = 'devops-test-react-app'
        AWS_ECR_URL = '760761285600.dkr.ecr.us-east-1.amazonaws.com'
        AWS_CREDENTIAL_ID = 'ChamathAwsKey'
    }

    stages {
        stage('Build image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}", "--build-arg APP_NAME=\"${APP_NAME}\" -f Dockerfile .")
                }
            }
        }

        stage('Push image') {
            steps {
                script {
                    docker.withRegistry("https://${AWS_ECR_URL}", "ecr:us-east-1:${AWS_CREDENTIAL_ID}") {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }
    }

}