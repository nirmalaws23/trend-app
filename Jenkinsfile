pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nirmal1126/trend-app'
        DOCKER_CREDS = 'dockerhub-credentials'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    sh 'docker build -t $DOCKER_IMAGE:$IMAGE_TAG .'
                    sh 'docker tag $DOCKER_IMAGE:$IMAGE_TAG $DOCKER_IMAGE:latest'
                }
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
                    sh 'docker push $DOCKER_IMAGE:$IMAGE_TAG'
                    sh 'docker push $DOCKER_IMAGE:latest'
                    sh 'docker logout'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f ingress.yaml'

                sh 'kubectl set image deployment/trend-app trend-app=$DOCKER_IMAGE:$IMAGE_TAG'
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
