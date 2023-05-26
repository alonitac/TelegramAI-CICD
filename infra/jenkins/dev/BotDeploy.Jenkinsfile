pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            alwaysPull true
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.4'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_ENV = "dev"
    }

    stages {
        stage('Bot Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    k8s_yaml=$(cat infra/k8s/bot.yaml)
                    echo "k8s_yaml: " ${k8s_yaml}
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/env-cm-${APP_ENV}.yaml -n ${APP_ENV}
                    helm upgrade bot ./devops/helm/bot -n ${APP_ENV} || helm install bot ./devops/helm/bot -n ${APP_ENV}
                    '''
                }
            }
        }
    }
}