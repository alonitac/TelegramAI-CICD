pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/matan-jenkinsagent-cicd:1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_ENV = "dev"
    }

    parameters {
        string(name: 'WORKER_IMAGE_NAME')
    }

    stages {
        stage('yaml preparation'){
            steps{
                sh "sed 's|dynamic_worker_image|$WORKER_IMAGE_NAME|g; s|env_to_replace|$APP_ENV|g' infra/k8s/worker.yaml > infra/k8s/worker_deploy.yaml"
            }
        }

        stage('worker Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    # apply the configurations to k8s cluster
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/worker_deploy.yaml -n dev
                    '''
                }
            }
        }
    }
}