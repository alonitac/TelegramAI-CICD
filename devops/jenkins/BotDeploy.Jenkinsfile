pipeline {
    agent {
        docker {
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.4'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        AWS_ACCESS_KEY    = credentials('AWS_ACCESS_KEY')
        AWS_ACCESS_SECRET = credentials('AWS_ACCESS_SECRET')
        APP_ENV = "dev"
    }

    stages {
        stage('Bot Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'EKSkubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    k8s_yaml=$(cat infra/k8s/bot.yaml)
                    echo "k8s_yaml: " ${k8s_yaml}
                    aws sts get-caller-identity
                    aws configure set aws_access_key_id ${AWS_ACCESS_KEY}
                    aws configure set aws_secret_access_key ${AWS_ACCESS_SECRET}
                    aws sts get-caller-identity
                    aws eks list-clusters
                    aws eks update-kubeconfig --region eu-west-1 --name tamir-eks-test
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/env-cm-${APP_ENV}.yaml -n ${APP_ENV}
                    helm upgrade bot ./devops/helm/bot -n ${APP_ENV} || helm install bot ./devops/helm/bot -n ${APP_ENV}
                    '''
                }
            }
        }
    }
}