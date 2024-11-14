pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = '021891574443.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = 'aws-cost-flask-app'
        IMAGE_TAG = "latest"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build --no-cache -t ${ECR_REPOSITORY}:${IMAGE_TAG} .'
            }
        }

        stage('Push Docker Image to ECR') {
            environment {
                ECR_CREDENTIALS = credentials('ecr-credentials')
            }
            steps {
                script {
                    sh '''
                    echo ${ECR_CREDENTIALS_PSW} | docker login --username ${ECR_CREDENTIALS_USR} --password-stdin ${ECR_REGISTRY}
                    docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Apply Terraform Configuration') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
