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
        CONFIG_MAP_NAME = "config"
        CONFIG_MAP_DATA = "image=${BOT_IMAGE_NAME}"
    }

    parameters {
        string(name: 'BOT_IMAGE_NAME')
    }

    stages {
            stage('Create ConfigMap') {
                steps {
                    withCredentials([
                        file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                    ]) {
                        sh """
                            # create ConfigMap
                            echo ${CONFIG_MAP_DATA} | kubectl --kubeconfig ${KUBECONFIG} create configmap ${CONFIG_MAP_NAME} --from-env-file=-

                            # check if ConfigMap is created
                            kubectl --kubeconfig ${KUBECONFIG} get configmap ${CONFIG_MAP_NAME} -o yaml
                        """
                    }
                }
            }

            stage('Bot Deploy') {
                steps {
                    withCredentials([
                        file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                    ]) {
                        sh '''
                        # apply the configurations to k8s cluster
                        kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/bot.yaml --namespace dev
                        aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.eu-north-1.amazonaws.com

                        '''
                    }
                }
            }
    }
}