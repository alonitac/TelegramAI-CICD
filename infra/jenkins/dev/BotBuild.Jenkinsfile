pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    parameters {
        string(name: 'Region', defaultValue:'eu-west-1')
        string(name: 'ECRRegistry', defaultValue:'700935310038.dkr.ecr.eu-west-1.amazonaws.com')
        string(name: 'ECRRepo', defaultValue: 'tamir/jenkins')
        string(name: 'ImageTag', defaultValue: 'latest')
        string(name: 'ImageName', defaultValue: 'bot')
        string(name: 'DockerFilePath', defaultValue: 'bot/Dockerfile')
    }
    environment {
        AWS_ACCESS_KEY    = credentials('AWS_ACCESS_KEY')
        AWS_ACCESS_SECRET = credentials('AWS_ACCESS_SECRET')
        DOCKER_IMG = ''
        FULL_DOCKER_IMG = ''
    }
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                version=$(cat bot/VERSION)
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                git status
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                version=$(cat bot/VERSION)
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}

                cd ./deploy/terragrunt/eu-west-1/ecr/bot/
                terragrunt init
                terragrunt apply -lock=false -var=repo_name=${DOCKER_IMG} --auto-approve
                
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                docker push ${FULL_DOCKER_IMG}
                '''
            }
        }
        // stage('Trigger- Deploy') {
        //     steps {
        //         build job: 'BotDeploy', wait: false, parameters: [
        //             string(name: 'BOT_IMAGE_NAME', value: "700935310038.dkr.ecr.us-east-1.amazonaws.com/tamir/jenkins/bot:jenkins")
        //         ]
        //     }
        // }

                // docker build -f bot/Dockerfile -t 700935310038.dkr.ecr.us-east-1.amazonaws.com/tamir/jenkins/bot:jenkins .
                // aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.us-east-1.amazonaws.com
                
                
    }
}