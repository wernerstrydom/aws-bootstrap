/* groovylint-disable CompileStatic, LineLength */
pipeline {
    options {
        disableConcurrentBuilds()
    }
    agent none
    triggers {
        pollSCM 'H/2 * * * *'
    }
    environment {
        AWS_ACCESS_KEY_ID            = credentials('aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY        = credentials('aws-secret-access-key')
        TF_INPUT                     = 0
        TF_IN_AUTOMATION             = 'Jenkins'
        TF_BACKEND_S3_BUCKET         = credentials('terraform-backend-s3-bucket')
        TF_BACKEND_S3_REGION         = credentials('terraform-backend-s3-region')
        TF_BACKEND_S3_DYNAMODB_TABLE = credentials('terraform-backend-s3-dynamodb-table')
    }
    stages {
        stage('Plan') {
            agent any
            when {
                branch 'main'
            }
            steps {
                sh './setup.sh'
                sh './generate.sh'
                sh 'tools/terraform -v'
                sh 'tools/terraform init'
                sh 'tools/terraform apply -auto-approve'
            }
        }
    }
}
