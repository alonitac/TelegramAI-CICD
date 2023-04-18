pipeline {
    agent {
        docker {
            image '700935310038.dkr.ecr.eu-north-1.amazonaws.com/aleksei-prod-jenkins-agent:latest'
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
        stage('yaml preparation'){
            steps{
                sh "sed 's|dynamic_image|$BOT_IMAGE_NAME|g; s|env_to_replace|$APP_ENV|g' infra/k8s/bot.yaml > infra/k8s/bot_deploy.yaml"
            }
        }

        stage('Bot Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    # apply the configurations to k8s cluster
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/bot_deploy.yaml -n dev
                    '''
                }
            }
        }
    }
}