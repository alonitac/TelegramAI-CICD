pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here 
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.2'
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
        VERSION_FILE = "VERSION"
        INTERNAL_WS = "/var/lib/jenkins/workspace/prod/worker/buildworker"
    }
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                ./${SCRIPTS_DIR}/increment-version.sh ${WORKER_DIR} ${VERSION_FILE}
                version=$(cat ${WORKER_DIR}/${VERSION_FILE})
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                echo 'FULL_DOCKER_IMG is :' ${FULL_DOCKER_IMG}
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} .
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                version=$(cat ${WORKER_DIR}/${VERSION_FILE})
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
                echo $FULL_DOCKER_IMG > "${WORKER_DIR}/latest_img_worker"
                git config --global --add safe.directory ${INTERNAL_WS}
                git config remote.origin.url "https://${GITHUB_TOKEN}@github.com/TamirNator/TelegramAI-CICD"
                cat "${WORKER_DIR}/${VERSION_FILE}"
                worker_image_name=$(cat worker/latest_img_worker)
                echo "worker_image_name: ${worker_image_name}"
                worker_img=${worker_image_name} yq -i '.spec.template.spec.containers[0].image=env(worker_img)' infra/k8s/bot.yaml
                chmod u+x ./${SCRIPTS_DIR}/git-push.sh
                ./${SCRIPTS_DIR}/git-push.sh "${WORKER_DIR}/${VERSION_FILE} ${WORKER_DIR}/latest_img_worker" ${GIT_BRANCH##*/} '[skip ci] updated version from Jenkins Pipeline'
                '''
                
                build job: 'deployworker', wait: false
                
            }
        }
     }
    post {
        always {
        cleanWs { // Clean after build
            cleanWhenAborted(true)
            cleanWhenFailure(true)
            cleanWhenNotBuilt(false)
            cleanWhenSuccess(true)
            cleanWhenUnstable(true)
            deleteDirs(true)
            notFailBuild(true)
            disableDeferredWipeout(true)
            patterns {
                pattern {
                    type('EXCLUDE')
                    pattern('.propsfile')
                }
                pattern {
                    type('INCLUDE')
                    pattern('.gitignore')
                }
        }
        success {
            echo 'I succeeded!'
            echo 'Cleaning workspace... '
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before... '
        }    
    }
}