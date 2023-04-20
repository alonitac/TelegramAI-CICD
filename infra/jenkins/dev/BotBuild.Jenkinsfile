pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins/agent:latest'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    parameters {
        string(name: 'Message', defaultValue:'default testing params !!')
        string(name: 'Region', defaultValue:'eu-west-1')
        string(name: 'ECRRegistry', defaultValue:'700935310038.dkr.ecr.eu-west-1.amazonaws.com/tamir/jenkins')
    }
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -f bot/Dockerfile -t ${ECRRegistry}/bot-test:latest .
                aws ecr get-login-password --region ${Region} | docker login --username AWS --password-stdin ${ECRRegistry}
                aws ecr create-repository --repository-name tamir/jenkins/bot-test --region ${Region} || true
                docker push ${ECRRegistry}/bot-test:jenkins
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
                // docker push 700935310038.dkr.ecr.us-east-1.amazonaws.com/tamir/jenkins/bot:jenkins
                
    }
}