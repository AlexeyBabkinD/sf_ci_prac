pipeline {
    agent {label 'docker'}
    stages {
        stage('check-site'){
            steps {
                script{
                    sh 'docker build . -t my_nginx'
                    sh 'docker run --name check-site -p 9889:80 my_nginx &'
                    sh 'sleep 5'
                    sh 'docker exec -it check-site md5sum /usr/share/nginx/html/index.html'
                    sh 'docker stop check-site && docker rmi my_nginx -f'
                }
            }
        }
    }
}
