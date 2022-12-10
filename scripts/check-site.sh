#!/bin/bash

echo "Build docker image"
docker build . -t my_nginx > /dev/null

echo "Run docker container"
docker run --name check-site -p 9889:80 my_nginx > /dev/null 2>&1 &
sleep 5

echo "Check curl status"
resp_status=$(curl -I http:// 10.128.0.252:9889 >/dev/null | head -n 1 | cut -d$' ' -f2)
echo "$resp_status"

echo "Get md5sum index.html in container"
index_docker=$(docker exec check-site md5sum /usr/share/nginx/html/index.html)
index_docker=$(echo $index_docker | awk '{ print $1 }')

echo "Get md5sum index.html in repo"
index_repo=$(md5sum ./index.html | awk '{ print $1 }')

echo "Remove docker"
docker stop check-site > /dev/null
docker rm check-site > /dev/null
docker rmi my_nginx -f > /dev/null

echo "Check index files sums"
if [ $index_repo == $index_docker ]; then
	echo "files match"
else
	echo "files not match"
	exit 1
fi

