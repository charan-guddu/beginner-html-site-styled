pipeline {
    agent {
        kubernetes {
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: jnlp
                image: jenkins/inbound-agent:latest
                args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
              - name: docker
                image: docker:20.10.7-dind
                securityContext:
                  privileged: true
                volumeMounts:
                  - name: docker-sock
                    mountPath: /var/run/docker.sock
              volumes:
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
            """
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
                git branch: 'gh-pages', url: 'https://github.com/charan-guddu/beginner-html-site-styled.git'
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
