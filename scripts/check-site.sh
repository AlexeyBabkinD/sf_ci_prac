#!/bin/bash

echo "Build docker image"
docker build . -t my_nginx
echo "Run docker container"
docker run --name check-site -p 9889:80 my_nginx > /dev/null 2>&1 &
sleep 5
echo "Get md5sum index.html in container"
index_docker=$(docker exec check-site md5sum /usr/share/nginx/html/index.html)
index_docker=$(echo $index_docker | awk '{ print $1 }')
echo "Remove docker"
docker stop check-site && docker rm check-site && docker rmi my_nginx -f

