#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-secret-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }
    stages {
        stage('provision cluster') {
            environment {
               TF_VAR_env_prefix = "dev"
               TF_VAR_k8s_version = "1.28"
               TF_VAR_cluster_name = "my-cluster"
               TF_VAR_region = "us-east-1"
            }
            steps {
                script {
                    echo "Creating EKS cluster..."
                    sh "terraform init"
                    sh "terraform apply -var-file="dev.tfvars" --auto-approve"

                    env.K8S_CLUSTER_URL = sh(
                        script: "terraform output cluster_url",
                        returnStdout: true
                    ).trim()

                    sh "aws eks update-kubeconfig --name ${TF_VAR_cluster_name} --region ${TF_VAR_region}"
                }
            }
        }
    }
}