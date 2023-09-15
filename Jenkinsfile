pipeline{
    agent any

    stages{
        stage("Checkout") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    deleteDir()
                    checkout scm
                }
            }
        }

        stage('Maven') {
            agent {
                docker {
                    image 'maven:3.6.3-jdk-8'
                    args '--network ci_network'
                }
            }

            stages {
                stage('Compile') {
                    steps {
                        configFileProvider([configFile(fileId: 'maven-settings-toxic', variable: 'MAVEN_SETTINGS')]) {
                            script {
                                sh "mvn compile -s $MAVEN_SETTINGS"
                            }
                        }
                    }
                }

                stage('Test') {
                    steps {
                        configFileProvider([configFile(fileId: 'maven-settings-toxic', variable: 'MAVEN_SETTINGS')]) {
                            script {
                                sh "mvn test -s $MAVEN_SETTINGS"
                            }
                        }
                    }
                }

                stage("Verify") {
                    when {
                        expression { BRANCH_NAME == 'main' }
                    }
                    steps {
                        timeout(time: 5, unit: 'MINUTES') {
                            configFileProvider([configFile(fileId: 'maven-settings-toxic', variable: 'MAVEN_SETTINGS')]) {
                                script {
                                    sh "mvn verify -s $MAVEN_SETTINGS"
                                    stash include: "./target/*", name: 'app'
                                }
                            }
                        }
                    }
                }
            }
        }

        stage("dockerize") {
            steps {
                unstash 'app'
                sh 'docker build -t toxictypo .'
            }
        }

        stage("Push to ECR") {
            when {
                expression { BRANCH_NAME == 'main' }
            }
            steps {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-east-1.amazonaws.com"
                sh "docker tag toxictypo:latest 644435390668.dkr.ecr.us-east-1.amazonaws.com/arthur-toxic:latest"
                sh "docker push 644435390668.dkr.ecr.us-east-1.amazonaws.com/arthur-toxic:latest"
            }
        }
    }

    post {
        always {
            script {
                // Revert changes to tracked files
                sh 'git reset --hard'
                // Remove untracked files and directories
                sh 'git clean -fd'
            }
        }
    }
}
