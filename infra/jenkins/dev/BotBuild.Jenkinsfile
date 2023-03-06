pipeline {
    agent {
        docker {
            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/lidoror-jenkinsagent-k0s:1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        retry(2)
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        IMAGE_NAME = 'lidoror-bot-k0s'
        IMAGE_TAG = "${GIT_COMMIT}"
        REPO_URL = '700935310038.dkr.ecr.us-west-2.amazonaws.com/lidoror-bot-k0s'
    }

    stages {
        stage('ECR Login') {
            steps {
                
                sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.us-west-2.amazonaws.com'
            }
        }
        stage('Image Build') {
            steps {
                sh "docker build -t ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG} -f bot/Dockerfile ."
            }
        }

        stage('Image Push') {
            steps {
                sh "docker push ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Trigger Deploy') {
            steps {
                build job: 'BotDeploy', wait: false, parameters: [
                    string(name: 'BOT_IMAGE_NAME', value: "<image-name>")
                ]
            }
        }
    }
}