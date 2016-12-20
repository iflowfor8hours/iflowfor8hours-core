#!/bin/bash
# Create a production and non-prod BASEURL environment variable in pipeline configuration
set -e

if [ -z "${BASEURL}" ]; then 
    HUGO_BASEURL='https://localhost/'
else 
    HUGO_BASEURL=${BASEURL}
fi

env HUGO_BASEURL=${HUGO_BASEURL} hugo --cleanDestinationDir
docker build -t iflowfor8hours:blog .

echo HUGO_BASEURL=${HUGO_BASEURL}
echo docker run --rm --name bakedblog -p 80:80 -p 443:443 iflowfor8hours:blog
