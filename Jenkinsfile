pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'  // Región de AWS
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
                 withCredentials([aws(credentialsId: 'AWS-CREDENTIALS')]) { // Reemplaza 'my-aws-credentials' con tu ID de credenciales
                    dir('challangue-ejercicio-4/terraform') {  // Cambia al directorio correcto
                        sh 'pwd'  // Verifica el directorio
                        sh 'terraform init'  // Ejecuta terraform plan
                        sh 'terraform apply -auto-aprove'
                    }
                }
            }
        }
    }
}