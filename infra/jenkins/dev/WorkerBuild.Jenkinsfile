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
        SCRIPTS_DIR = "devops/scripts"
        JENKINS_WS = "/var/lib/jenkins/workspace"
        WORKER_DIR = "worker"
        GITHUB_REPO = "https://${env.GITHUB_TOKEN}@github.com/TamirNator/TelegramAI-CICD"
        VERSION_FILE = "VERSION"
    }
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                echo 'FULL_DOCKER_IMG is :' ${FULL_DOCKER_IMG}
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                version=$(cat ${WORKER_DIR}/${VERSION_FILE})
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                ./${SCRIPTS_DIR}/increment-version.sh ${WORKER_DIR} ${VERSION_FILE}
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                version=$(cat ${WORKER_DIR}/${VERSION_FILE})
                DOCKER_IMG=${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                docker push ${FULL_DOCKER_IMG}
                '''
            }
        }
        stage('Trigger- Deploy') {
            steps {
                sh '''
                version=$(cat ${WORKER_DIR}/${VERSION_FILE})
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                echo "FULL_DOCKER_IMG:" ${FULL_DOCKER_IMG}
                echo $FULL_DOCKER_IMG > ${WORKER_DIR}/latest_img_worker
                git config --global --add safe.directory ${JENKINS_WS}/dev/worker/BuildWorker
                git config remote.origin.url "${GITHUB_REPO}"
                cat ${WORKER_DIR}/${VERSION_FILE}
                chmod u+x ./${SCRIPTS_DIR}/git-push.sh
                ./${SCRIPTS_DIR}/git-push.sh '${WORKER_DIR}/${VERSION_FILE} ${WORKER_DIR}/latest_img_worker' ${GIT_BRANCH##*/} '[skip ci] updated version from Jenkins Pipeline'
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