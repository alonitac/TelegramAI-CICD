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
        string(name: 'FULL_DOCKER_IMG' , defaultValue: '')
    }
    environment {
        AWS_ACCESS_KEY    = credentials('AWS_ACCESS_KEY')
        AWS_ACCESS_SECRET = credentials('AWS_ACCESS_SECRET')
        GITHUB_TOKEN = credentials('github_access_token')
        DOCKER_IMG = ''
    }
    stages {
        stage('DockerBuild') {
            steps {
                echo "Test"
                sh '''
                echo 'FULL_DOCKER_IMG is :' ${FULL_DOCKER_IMG}
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${ImageTag}
                ./deploy/terragrunt/scripts/increment-version.sh worker VERSION
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} .
                '''
            }
        }
        // stage('DockerPush') {
        //     steps {
        //         sh '''
        //         DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
        //         FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${ImageTag}
        //         cd ./deploy/terragrunt/eu-west-1/ecr/worker/
        //         terragrunt init
        //         terragrunt apply -lock=false -var=repo_name=${DOCKER_IMG} --auto-approve
        //         aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
        //         docker push ${FULL_DOCKER_IMG}
        //         '''
        //     }
        // }
        stage('Trigger- Deploy') {
            steps {
                sh '''
                version=$(cat worker/VERSION)
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                echo "FULL_DOCKER_IMG:" ${FULL_DOCKER_IMG}
                echo $FULL_DOCKER_IMG > worker/latest_img_worker
                git config --global --add safe.directory /var/lib/jenkins/workspace/dev/worker/BuildWorker
                git config remote.origin.url "https://${GITHUB_TOKEN}@github.com/TamirNator/TelegramAI-CICD"
                cat worker/VERSION
                chmod u+x ./deploy/terragrunt/scripts/git-push.sh
                ./deploy/terragrunt/scripts/git-push.sh "worker/VERSION, worker/latest_img_worker" ${GIT_BRANCH##*/} '[skip ci] Add VERSION from Jenkins Pipeline'
                '''
                
                build job: 'DeployWorker', wait: false
                
            }
        }
    // TODO dev worker build stages here
     }

    post {
        // always {
        //     cleanWs(cleanWhenNotBuilt: false,
        //     deleteDirs: true,
        //     disableDeferredWipeout: true,
        //     notFailBuild: true,
        //     patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
        //                        [pattern: '.propsfile', type: 'EXCLUDE']])

        // }
        success {
            echo 'I succeeded!'
            echo 'Cleaning workspace... '
           // deleteDir() /* clean up our workspace */
            // sh '''
            // echo "sudo su - ec2-user find / -type f -name .terragrunt-cache -delete" 
            // '''
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