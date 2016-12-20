#!/bin/bash
hugo --cleanDestinationDir --baseURL http://localhost/
chmod -R 777 public
docker stop docker-nginx
docker rm -f docker-nginx
docker run --name iflowfor8hours-nginx-sidecar -v "$PWD"/public:/usr/share/nginx/html -v "$PWD"/dev/nginx.conf:/etc/nginx/nginx.conf:ro -p 80:80 nginx:alpine
