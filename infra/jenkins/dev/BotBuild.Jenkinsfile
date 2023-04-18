pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image 'public.ecr.aws/n5h8m9x0/tamir-jenkins:test'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Build') {
            steps {
                echo "testing building..."
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