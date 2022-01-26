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
        AWS_ECS_CLUSTER = 'DevOps-Test-Cluster'
        AWS_ECS_SERVICE = 'devops-test-react-app-service'
        AWS_ECS_TASK_DEF = 'devops-test-react-app-task'
        AWS_CREDENTIAL_ID = 'ChamathAwsKey'
    }

    stages {
        stage('Build image') {
            steps {
                script {
                    sh "sed -i -e 's|%APP_NAME%|${APP_NAME}|g' docker-entrypoint.sh"
                    docker.build("${IMAGE_NAME}")
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

        stage('Deploy to ECS') {
            steps {
                sh 'aws ecs register-task-definition --cli-input-json file://ecs-task-definition.json'
                sh "aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEF}"
            }
        }
    }

}