pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/lidoror-jenkinsagent-k0s:1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_NAME = "bot"
        APP_ENV = "dev"
        K8S_DEPLOYMENT_FILE = "bot_to_deploy.yaml"
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
                    # apply the configurations to k8s cluster
                    kubectl apply --kubeconfig ${KUBECONFIG} -f ${K8S_DEPLOYMENT_FILE}
                    '''
                }
            }
        }
    }
}