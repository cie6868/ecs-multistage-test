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
        IMAGE_NAME = 'devops-test-react-app'
        AWS_ECR_URL = '760761285600.dkr.ecr.us-east-1.amazonaws.com'
        AWS_CREDENTIAL_ID = 'ChamathAwsKey'
    }

    stages {
        stage('Build image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Push image') {
            steps {
                script {
                    docker.withRegistry("https://${AWS_ECR_URL}", "${AWS_CREDENTIAL_ID}") {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }
    }

}