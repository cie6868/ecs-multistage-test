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
        AWS_ECS_REGION = 'us-east-1'
        AWS_ECS_CLUSTER = 'DevOps-Test-Cluster'
        AWS_ECS_SERVICE = 'devops-test-react-app-service'
        AWS_ECS_TASK_DEF = 'devops-test-react-app-task'
        AWS_ECS_EXEC_ROLE_ARN = 'arn:aws:iam::760761285600:role/ecsTaskExecutionRole'
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
                withCredentials(
                    [
                        [
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: "${AWS_CREDENTIAL_ID}",
                            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]
                ) {
                    sh "aws ecs register-task-definition --region ${AWS_ECS_REGION} --family ${AWS_ECS_TASK_DEF} --execution-role-arn ${AWS_ECS_EXEC_ROLE_ARN} --requires-compatibilities FARGATE --network-mode awsvpc --cpu 256 --memory 512 --container-definitions file://ecs-container-definition.json"
                    sh "aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEF}"
                }
            }
        }
    }

}