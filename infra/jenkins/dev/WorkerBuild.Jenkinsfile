pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.us-east-1.amazonaws.com/tamir/jenkins/agent:latest'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    parameters {
        string(name: 'Region', defaultValue:'eu-west-1')
        string(name: 'ECRRegistry', defaultValue:'700935310038.dkr.ecr.eu-west-1.amazonaws.com')
        string(name: 'ECRRepo', defaultValue: 'tamir/jenkins')
        string(name: 'ImageTag', defaultValue: 'latest')
        string(name: 'ImageName', defaultValue: 'worker')
        string(name: 'DockerFilePath', defaultValue: 'worker/Dockerfile')
    }
    environment {
        AWS_ACCESS_KEY    = credentials('AWS_ACCESS_KEY')
        AWS_ACCESS_SECRET = credentials('AWS_ACCESS_SECRET')
    }
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                docker build -f ${DockerFilePath} -t ${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${ImageTag} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                cd ./deploy/terragrunt/eu-west-1/ecr/worker/
                terragrunt init
                terragrunt apply -lock=false -var=repo_name=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName} --auto-approve
                
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                docker push ${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${ImageTag}
                '''
            }
        }
    // TODO dev worker build stages here
    }
}