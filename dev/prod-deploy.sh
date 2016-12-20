#!/bin/bash
set -e

eval $(docker-machine env iflowfor8hours-core)
export DOCKER_API_VERSION=1.23
HUGO_BASEURL=https://iflowfor8hours.info/ 

hugo --cleanDestinationDir
docker build -t iflowfor8hours:blog .

RUNNING_VERSION=(`docker ps | grep blog | cut -f 1 -d ' '`)
DATE=(date +%s)
docker rm -f ${RUNNING_VERSION}
docker run -d --name bakedblog-${DATE} -p 80:80 -p 443:443 iflowfor8hours:blog
