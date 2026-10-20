pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling code from repository....'
                git branch: 'main', credentialsId: 'gituser', url: 'https://github.com/alnayyarnader/my_depi_project.git'
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling and packaging application...'
                // Replace this with your project build command (e.g., mvn clean package, npm run build, etc.):
                sh '''
                    echo 'Starting build process...'
                    mkdir -p build/
                    echo 'Build artifact compiled successfully' > build/app.log
                '''
            }
        }

        stage('Test') {
            stages {
                stage('Parallel Testing Block') {
                    parallel {
                        stage ('Unit Testing') {
                            steps {
                                echo 'Starting Unit Testing process...'
                            }
                        }
                        stage ('Integration Testing') {
                            steps {
                                echo 'Starting Integration Testing process...'
                            }
                        }
                    }
                }
                
                
                stage('Subsequent Parallel Tests') {
                    parallel {
                        stage ('Smoke Testing') {
                            steps {
                                echo 'Starting Smoke Testing process...'
                            }
                        }
                        stage ('Sanity Testing') {
                            steps {
                                echo 'Starting Sanity Testing process...'
                            }
                        }
                        stage ('E2E Testing') {
                            stages {
                                stage('Nested E2E_1') {
                                    steps {
                                       echo 'Starting Nested E2E_1 Testing process...' 
                                    }
                                }
                                stage('Nested E2E_2') {
                                    steps {
                                        echo 'Starting Nested E2E_2 Testing process...' 
                                    }
                                }
                                stage('Nested E2E_3') {
                                    steps {
                                        echo 'Starting Nested E2E_2 Testing process...' 
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
            // Clean up workspace if needed:
            // cleanWs()
        }
        success {
            echo 'Build and test stages succeeded!'
        }
        failure {
            echo 'Pipeline failed. Check stage console outputs for errors.'
        }
    }
}

