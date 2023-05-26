pipeline {
    agent {
        docker {
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.4'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_ENV = "dev"
    }

    parameters {
        string(name: 'worker_image_name')
    }

    stages {
        stage('Worker Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    k8s_yaml=$(cat infra/k8s/bot.yaml)
                    echo "k8s_yaml: " ${k8s_yaml}
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/env-cm-dev.yaml --namespace dev
                    helm upgrade worker ./devops/helm/worker -n dev || helm install worker ./devops/helm/worker -n dev
                    '''
                }
            }
        }
    }
}