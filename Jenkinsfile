pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'nirmalaws23/trend-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/nirmalaws23/trend-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        dockerImage.push("${IMAGE_TAG}")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-credentials']) {
                    sh """
                    sed -i 's|DOCKER_HUB_USERNAME/trend-app:latest|${DOCKER_HUB_REPO}:${IMAGE_TAG}|g' k8s/deployment.yaml
                    kubectl apply -f k8s/deployment.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}