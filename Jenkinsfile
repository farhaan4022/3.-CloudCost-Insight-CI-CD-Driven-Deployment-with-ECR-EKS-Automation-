pipeline {
    agent any
    environment {
        // Define environment variables for AWS and Docker
        AWS_REGION = 'us-east-1'
        ECR_REPO_NAME = 'your-ecr-repository-name'  // Replace with your ECR repository name
        ECR_URI = "aws_account_id.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"  // Replace aws_account_id
        IMAGE_TAG = "latest"
        KUBE_CONFIG_PATH = "/path/to/kubeconfig"  // Path to your kubeconfig file
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your repository
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${ECR_URI}:${IMAGE_TAG} ."
                }
            }
        }
        
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Tag the Docker image and push it to ECR
                    sh """
                    docker tag ${ECR_URI}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                    docker push ${ECR_URI}:${IMAGE_TAG}
                    """
                }
            }
        }
        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }
        stage('Plan Terraform') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform configuration to provision infrastructure
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Update Kubeconfig ') {
            steps {
                script {
                    // Update kubeconfig for access to the EKS cluster
                    sh """
                    aws eks --region ${AWS_REGION} update-kubeconfig --name my-eks-cluster
                    """
                    
                    // Create Kubernetes secret for Docker registry (ECR)
                    sh """
                    kubectl create secret docker-registry ecr-secret \
                        --docker-server=${ECR_URI} \
                        --docker-username=AWS \
                        --docker-password=$(aws ecr get-login-password --region ${AWS_REGION}) \
                        --docker-email=your-email@example.com || true
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes deployment YAML
                    withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG')]) {
                        sh "kubectl --kubeconfig=${KUBECONFIG} apply -f cloud-cost-deployment.yaml"
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up Docker images and containers to free resources
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
