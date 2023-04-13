pipeline {
    agent {
        docker {

            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/matan-jenkinsagent-cicd:1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    environment {
    REGISTRY_URL = '700935310038.dkr.ecr.us-west-2.amazonaws.com'
    IMAGE_NAME = 'matan-dev-worker'
    IMAGE_TAG = '${BUILD_NUMBER}'
    }

    stages {
        stage('Build') {
            steps {

                sh '''
                aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $REGISTRY_URL
                docker build -t $IMAGE_NAME:$BUILD_NUMBER -f worker/Dockerfile .
                docker tag $IMAGE_NAME:$BUILD_NUMBER $REGISTRY_URL/$IMAGE_NAME:$BUILD_NUMBER
                docker push $REGISTRY_URL/$IMAGE_NAME:$BUILD_NUMBER
                '''
            }
            post {
                always{
                    sh 'docker image prune -a --filter "until=64h" --force'
                }
            }
        }
        stage('Trigger Deploy') {
            steps {
                build job: 'workerDeploy', wait: false, parameters: [
                    string(name: 'WORKER_IMAGE_NAME', value: "$REGISTRY_URL/$IMAGE_NAME:$BUILD_NUMBER")
                ]
            }
        }
    }
}