pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_ENV = "dev"
    }

    parameters {
        string(name: 'BOT_IMAGE_NAME')
    }

    stages {
        stage('Bot Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    echo "image_name: " ${BOT_IMAGE_NAME}  
                    '''
                }
            }
        }
    }
}
// # apply the configurations to k8s cluster
// ####testingggg
// kubectl apply --kubeconfig ${KUBECONFIG} -f <path-to-bot-yaml-k8s-manifest>