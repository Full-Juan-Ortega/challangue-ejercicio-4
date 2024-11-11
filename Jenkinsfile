pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('01-salida-por-consola') {
            steps {
                echo 'Hello World'
            }
        }
        stage('02-git-pull') {
            steps {
                sh 'rm -rf challangue-ejercicio-4'
                sh 'git clone https://github.com/Full-Juan-Ortega/challangue-ejercicio-4.git'
            }
        }
        /*stage('List S3 Buckets') {
            steps {
                withCredentials([aws(credentialsId: 'AWS-CREDENTIALS')]) { 
                    sh 'aws s3 ls'
                }
            }
        }*/
        

        stage('terraform apply') {
            steps {
                 withCredentials([aws(credentialsId: 'AWS-CREDENTIALS')]) { 
                    dir('challangue-ejercicio-4/terraform') {  
                        sh 'pwd'  
                        sh 'terraform init'  
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}