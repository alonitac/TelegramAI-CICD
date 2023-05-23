pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here 
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:1.4'
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
        string(name: 'FULL_DOCKER_IMG' , defaultValue: '')
    }
    environment {
        AWS_ACCESS_KEY    = credentials('AWS_ACCESS_KEY')
        AWS_ACCESS_SECRET = credentials('AWS_ACCESS_SECRET')
        GITHUB_TOKEN = credentials('github_access_token')
        DOCKER_IMG = ''
        SCRIPTS_DIR = "devops/scripts"
        JENKINS_WS = "/var/lib/jenkins/workspace"
        BOT_DIR = "bot"
        VERSION_FILE = "VERSION"
        INTERNAL_WS = "/var/lib/jenkins/workspace/dev/bot/BuildBot"
    }
    stages {
        stage('DockerBuild') {
            steps {
                sh '''
                ./${SCRIPTS_DIR}/increment-version.sh ${BOT_DIR} ${VERSION_FILE}
                version=$(cat ${BOT_DIR}/${VERSION_FILE})
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                echo 'FULL_DOCKER_IMG is :' ${FULL_DOCKER_IMG}
                docker build -f ${DockerFilePath} -t ${FULL_DOCKER_IMG} . --build-arg ENV="dev"
                '''
            }
        }
        stage('DockerPush') {
            steps {
                sh '''
                version=$(cat ${BOT_DIR}/${VERSION_FILE})
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                docker push ${FULL_DOCKER_IMG}
                '''
            }
        }
        stage('Trigger- Deploy') {
            steps {
                scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                sh '''
                version=$(cat ${BOT_DIR}/${VERSION_FILE})
                FULL_DOCKER_IMG=${ECRRegistry}/${ECRRepo}/${GIT_BRANCH##*/}/${ImageName}:${version}
                echo "FULL_DOCKER_IMG:" ${FULL_DOCKER_IMG}
                echo $FULL_DOCKER_IMG > "${BOT_DIR}/latest_img_bot"
                git config --global --add safe.directory ${INTERNAL_WS}
                git config remote.origin.url "https://${GITHUB_TOKEN}@github.com/TamirNator/TelegramAI-CICD"
                cat "${BOT_DIR}/${VERSION_FILE}"
                bot_image_name=$(cat bot/latest_img_bot)
                echo "bot_image_name: ${bot_image_name}"
                bot_img=${bot_image_name} yq -i '.spec.template.spec.containers[0].image=env(bot_img)' infra/k8s/bot.yaml
                chmod u+x ./${SCRIPTS_DIR}/git-push.sh
                ./${SCRIPTS_DIR}/git-push.sh "${BOT_DIR}/${VERSION_FILE} ${BOT_DIR}/latest_img_bot infra/k8s/bot.yaml" ${GIT_BRANCH##*/} \
                    '[ci skip] updated version from Jenkins Pipeline'
                '''
                build job: 'DeployBot', wait: false
            }
        }
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
            echo 'Cleaning workspace...'
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
}