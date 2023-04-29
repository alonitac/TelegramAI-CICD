pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here.
            image '700935310038.dkr.ecr.eu-north-1.amazonaws.com/aleksei-prod-jenkins-agent'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    environment {
    REGISTRY_URL = '700935310038.dkr.ecr.eu-north-1.amazonaws.com'
    IMAGE_NAME = 'aleksei-bot-dev'
    IMAGE_TAG = '${BUILD_NUMBER}'

        }
    }
}