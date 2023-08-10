pipeline {
    agent any
    environment {
        DATABASE_URL = 'postgresql://localhost/my_test_database?pool=5'
        ACCESS_KEY_ID = credentials('access-key-id')
        SECRET_ACCESS_KEY = credentials('secret-access-key')
        DISABLE_AUTH = true
    }
    stages {
        stage("Build") {
            steps {
                echo "Building the app..."
                sh '''
                    echo "This block contains multi-line steps"
                    ls -lh
                '''
            }
        }
        stage("Test") {
            steps {
                echo "Testing the app..."
            }
        }
        stage("Deploy") {
            steps {
                echo "Deploying the app..."
            }
        }
    }
    post {
      always {
          echo "This will always run regardless of the completion status"
      }
      success {
          echo "This will run if the build succeeded"
      }
      failure {
          echo "This will run if the job failed"
      }
      unstable {
          echo "This will run if the completion status was 'unstable', usually by test failures"
      }
      changed {
          echo "This will run if the state of the pipeline has changed"
          echo "For example, if the previous run failed but is now successful"
      }
      fixed {
          echo "This will run if the previous run failed or unstable and now is successful"
      }
      cleanup {
          echo "Cleaning the workspace"
          cleanWs()
      }
    }
}