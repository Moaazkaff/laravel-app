pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }

    stages{
        
        stage("Docker login"){
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage("Build & Push Dockerfile"){
            steps{
                sh 'ansible-playbook playbook1.yml'
            }
        }

        stage(""){
            steps{
                sh 'ansible-playbook playbook2.yml'
            }
        }

    }
}