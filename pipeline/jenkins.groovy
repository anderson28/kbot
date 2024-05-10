pipeline {
    
    agent any
    
    parameters {
        choice(name: 'OS', choices: ['linux', 'windows', 'darwin', 'all'], description: 'select OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'select Arch')
    }

    environment {
        REPO = 'https://github.com/anderson28/kbot'
        BRANCH = 'main'
        TARGETOS="${params.OS}"
        TARGETARCH="${params.ARCH}"
    }

    stages {
        stage('Info') {
            steps {
                echo "Build for platform ${TARGETOS}"
                echo "Build for arch: ${TARGETARCH}"
            }
        }

        stage('Git checkout') {
            steps {
                git branch: BRANCH, url: REPO
            }
        }

        stage('Test') {
            steps {
                echo 'Testing'
                sh 'make test'
            }
        }

        stage('Make image') {
            steps {
                echo 'Make image'
                sh "make image"
            }
        }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        sh 'make push'
                    }
                }
            }
        }
    }
}