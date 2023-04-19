pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.us-east-1.amazonaws.com/tamir/jenkins/agent:test'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    parameters {
        string(name: 'Message', defaultValue:'default params')
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo "${Message}"'
                sh 'echo more testing...'
            }
        }

        // stage('Trigger Deploy') {
        //     steps {
        //         build job: 'BotDeploy', wait: false, parameters: [
        //             string(name: 'BOT_IMAGE_NAME', value: "<image-name>")
        //         ]
        //     }
        // }
    }
}