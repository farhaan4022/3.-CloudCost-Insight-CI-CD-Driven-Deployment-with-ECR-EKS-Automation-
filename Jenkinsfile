pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                // Add your build steps here
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                // Add your push steps here
            }
        }

        stage('Initialize Terraform') {
            steps {
                // Add your initialization steps here
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                // Add your planning steps here
            }
        }

        stage('Apply Terraform Configuration') {
            steps {
                // Add your apply steps here
            }
        }

        stage('Update kubeconfig') {
            steps {
                // Add your kubeconfig update steps here
            }
        }

        stage('Deploy to Cluster') {
            steps {
                // Add your deployment steps here
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
