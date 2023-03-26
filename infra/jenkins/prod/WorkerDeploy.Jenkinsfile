pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-north-1.amazonaws.com/url-jenkins-agent:latest'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_ENV = "prod"
    }

    parameters {
        string(name: 'WORKER_IMAGE_NAME')
    }

    stages {
        stage('Worker Deploy') {
            steps {
                echo "${APP_ENV}"
                echo "${WORKER_IMAGE_NAME}"
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    # apply the configurations to k8s cluster
                    sed -i "s|WORKER_IMAGE|$WORKER_IMAGE_NAME|g" infra/k8s/worker.yaml
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/worker.yaml --namespace prod
                    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.eu-north-1.amazonaws.com

                    '''
                }
            }
        }
    }
}
