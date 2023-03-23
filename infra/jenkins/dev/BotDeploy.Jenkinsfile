pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-north-1.amazonaws.com/url-jenkins-agent:latest'
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
                    IMAGE_NAME=${BOT_IMAGE_NAME}
                    sed -i "s%IMAGE_NAME%$BOT_IMAGE_NAME%g" infra/k8s/bot.yaml
                    # apply the configurations to k8s cluster
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/bot.yaml --namespace dev
                    kubectl set image deployment/bot-deployment bot=$IMAGE_NAME --kubeconfig ${KUBECONFIG} -n dev
                    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.eu-north-1.amazonaws.com

                    '''
                }
            }
        }
    }
}