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
                    docker.withRegistry('https://760761285600.dkr.ecr.us-east-1.amazonaws.com', "ecr:${IMAGE_NAME}:${AWS_CREDENTIAL_ID}") {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }
    }

}