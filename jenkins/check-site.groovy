pipeline {
    agent {label 'docker'}
    stages {
        stage('check-site'){
            steps {
                script{
                    sh './scripts/check-site.sh'
                }
            }
        }
    }
}
