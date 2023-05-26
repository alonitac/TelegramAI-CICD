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
                    aws configure list
                    aws eks list-clusters
                    aws eks update-kubeconfig --region eu-west-1 --name tamir-eks-test --role-arn arn:aws:iam::700935310038:role/tamir-eks-test-cluster-20230526102719380800000005
                    aws sts get-caller-identity
                    kubectl apply --kubeconfig ${KUBECONFIG} -f infra/k8s/env-cm-${APP_ENV}.yaml -n ${APP_ENV}
                    helm upgrade bot ./devops/helm/bot -n ${APP_ENV} || helm install bot ./devops/helm/bot -n ${APP_ENV}
                    '''
                }
            }
        }
    }
}