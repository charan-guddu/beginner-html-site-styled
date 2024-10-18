pipeline {
    agent {
        kubernetes {
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
                containers:
                - name: linux
                  image: alpine:latest
                  command:
                  - cat
                  tty: true
            '''
        }
    }

    environment {
        DOCKER_HUB_REPO = "charanguddu/new-project"
        KUBERNETES_DEPLOYMENT = "deployment.yml"
        KUBERNETES_SERVICE = "service.yml"
    }

    stages {
        stage('Checkout') {
            steps {
                sh '''
                which git
                cat /etc/resolv.conf
                ping github.com
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f ${KUBERNETES_DEPLOYMENT}'
                sh 'kubectl apply -f ${KUBERNETES_SERVICE}'
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
