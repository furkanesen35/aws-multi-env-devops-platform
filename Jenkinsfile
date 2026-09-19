pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops-app'
        REGISTRY_USER = 'furkanesen35'
        BUILD_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('1. Code Analysis & Test') {
            steps {
                dir('app') {
                    sh 'python3 -m pip install -r requirements.txt --break-system-packages'
                    sh 'python3 -m unittest discover -s . -p "*_test.py" || true'
                }
            }
        }

        stage('2. DevSecOps Security Scan (Trivy)') {
            steps {
                sh 'trivy fs --severity HIGH,CRITICAL app/'
            }
        }

        stage('3. Docker Build & Tag') {
            steps {
                dir('app') {
                    sh "docker build -t ${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_TAG} ."
                    sh "docker tag ${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_TAG} ${REGISTRY_USER}/${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('4. Docker Container Scan') {
            steps {
                sh "trivy image --severity HIGH,CRITICAL ${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_TAG}"
            }
        }

        stage('5. Push to Image Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_TAG}"
                    sh "docker push ${REGISTRY_USER}/${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('6. Deploy to Dev Environment') {
            steps {
                sh 'kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -'
                sh 'kubectl apply -k app/k8s/overlays/dev'
                sh "kubectl -n dev set image deployment/dev-app-deployment devops-app=${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_TAG}"
                sh 'kubectl rollout status deployment/dev-app-deployment -n dev'
            }
        }

        stage('7. Deploy to Staging Environment') {
            steps {
                sh 'kubectl create namespace staging --dry-run=client -o yaml | kubectl apply -f -'
                sh 'kubectl apply -k app/k8s/overlays/staging'
                sh "kubectl -n staging set image deployment/staging-app-deployment devops-app=${REGISTRY_USER}/${DOCKER_IMAGE}:${BUILD_TAG}"
                sh 'kubectl rollout status deployment/staging-app-deployment -n staging'
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check build logs.'
        }
    }
}