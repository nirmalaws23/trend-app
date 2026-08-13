pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nirmal1126/trend-app:latest'
        DOCKER_CREDS = 'dockerhub-credentials'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/nirmalaws23/trend-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKER_CREDS}",
                        passwordVariable: 'DOCKER_PASSWORD',
                        usernameVariable: 'DOCKER_USER'
                    )
                ]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                    sh 'docker logout'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f ingress.yaml'
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl rollout status deployment/trend-app --timeout=120s'
                sh 'kubectl get pods -l app=trend-app'
                sh 'kubectl get svc trend-app-service'
                sh 'kubectl get ingress trend-app-ingress'
            }
        }
    }
}
