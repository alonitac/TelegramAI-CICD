pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:latest'
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
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                echo '{env.BRANCH_NAME}'
                docker build -f ${DockerFilePath} -t ${ECRRegistry}/${ECRRepo}/${ImageName}:${ImageTag} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                aws ecr describe-repositories --repository-names ${ECRRepo}/${ImageName} --region ${Region} 2>&1 > /dev/null
                status=$?
                if [[ ! "${status}" -eq 0 ]]; then
                    aws ecr create-repository --repository-name ${ECRRepo}/${ImageName} --region ${Region}
                else
                    echo "${ECRRepo}/${ImageName} in region ${Region} already exists"
                fi
                docker push ${ECRRegistry}/${ECRRepo}/${ImageName}:${ImageTag}
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