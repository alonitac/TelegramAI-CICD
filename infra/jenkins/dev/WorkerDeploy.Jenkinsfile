pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.3'
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
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/worker.yaml --namespace dev
                    kubectl create secret docker-registry aws-secret --docker-server=700935310038.dkr.ecr.eu-west-1.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password --region eu-west-1)
                    helm upgrade test-worker ./devops/helm/worker
                    '''
                }
            }
        }
    }
}