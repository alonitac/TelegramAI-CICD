def BRANCH_NAME
def DOCKER_IMG

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
                BRANCH_NAME=${GIT_BRANCH##*/}
                DOCKER_IMG=${ECRRepo}/${BRANCH_NAME}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${BRANCH_NAME}/${ImageName}:${ImageTag}
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                BRANCH_NAME=${GIT_BRANCH##*/}
                DOCKER_IMG=${ECRRepo}/${BRANCH_NAME}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${BRANCH_NAME}/${ImageName}:${ImageTag}
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                aws ecr describe-repositories --repository-names ${DOCKER_IMG} 2>&1 > /dev/null || true
                status=$?
                echo ${status}
                if [[ ! "${status}" -eq 0 ]]; then
                    aws ecr create-repository --repository-name ${DOCKER_IMG} --region ${Region}
                else
                    echo "${DOCKER_IMG} in region ${Region} already exists"
                fi
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