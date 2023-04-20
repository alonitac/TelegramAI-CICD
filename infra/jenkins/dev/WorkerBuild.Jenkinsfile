pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.us-east-1.amazonaws.com/tamir/jenkins/agent:latest'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
parameters {
        string(name: 'Message', defaultValue:'default testing params!!')
    }
    stages {
        stage('Build') {
            steps {
                sh '''
                echo "${Message}"
                '''
            }
        }
    // TODO dev worker build stages here
    }
}