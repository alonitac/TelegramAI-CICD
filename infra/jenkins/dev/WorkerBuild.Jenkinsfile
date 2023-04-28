pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here 
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.0'
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
        DOCKER_IMG = ''
        FULL_DOCKER_IMG = ''
    }
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${ImageTag}
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${ImageTag}
                cd ./deploy/terragrunt/eu-west-1/ecr/worker/
                terragrunt init
                terragrunt apply -lock=false -var=repo_name=${DOCKER_IMG} --auto-approve
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                docker push ${FULL_DOCKER_IMG}
                '''
            }
        }
        // stage('Trigger- Deploy') {
        //     steps {
        //         sh '''
        //         version=$(cat bot/VERSION)
        //         FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
        //         '''
        //         build job: 'DeployBot', wait: false, parameters: [
        //             string(name: 'BOT_IMAGE_NAME', value: "${FULL_DOCKER_IMG}")
        //         ]
        //     }
        // }
    // TODO dev worker build stages here
    }

        post {
        always {
            echo 'Cleaning up terraratnt cache ... '
            deleteDir() /* clean up our workspace  */
            sh '''
            sudo find / -type f -name .terragrunt-cache -exec rm {} \;
            '''
        }
        success {
            echo 'I succeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
        
        }  
    // TODO dev worker build stages here
    
}