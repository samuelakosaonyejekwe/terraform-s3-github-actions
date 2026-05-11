pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'eu-west-2'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                credentialsId: 'github-private-key',
                url: 'git@github.com:samuelakosaonyejekwe/terraform-s3-github-actions.git'
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}