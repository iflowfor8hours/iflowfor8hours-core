+++
layout = "single"
title = "Migrating this website to Containerized Infrastructure"
date = "2016-12-06"
tags = [
  "pipelines",
  "CD",
  "nginx",
  "containers",
  "blogging",
  "docker",
  "letsencrypt"
  ]

+++

The time has come to move off my statically Ubuntu VPS box on Digital Ocean and on to a more modern and containerized stack. 

_Why?_

My VPS was an aged 32-bit Ubuntu box, and I had not done much in terms of maintaining it for a long while. I considered upgrading, patching, and keeping it alive, but the configuration was kind of a _work of art_ and I didn't have anything that I really cared about on it. I experimented with a lot of things over the years, and I didn't config manage anything other than my dotfiles. I have some aspirations about different things I want to run on this box going forward in addition to just the blog, and isolating them in containers seems like a good idea.

My work with CoreOS and Docker at my dayjob inspired me to move to a containerized infrastructure. I'm aware that this is unnecessary, but I didn't want to go the Ansible plus static infrastructure route since I have been migrating clients off that for a while now. I'm documenting it because it was a fun exercise and others might benefit from it. Here is the existing infrastructure at the start:

Github -> Codeship Pipeline to `hugo` build, smoke test, rsync generated dir -> Digital Ocean box with NGINX and Let's Encrypt SSL.

Simple setup. I did not like the rsync and that I hand-rolled the letsencrypt stuff interactively. Nor did I like that the NGINX config was also manually built.

Here is the desired state:

Github push -> codeship Hugo build -> push to http staging env -> test -> containerize -> version artifact -> deploy to container host with SSL -> test -> chill.

I initially wanted to put letsencrypt into its own container and use NGINX reverse proxying so that I could terminate the SSL there and run the same blog artifact locally and remotely.

The plan initially looked something like this:

1. Build a container with nginx and the content to test locally
1. Create a pipeline to build and deploy to staging env
1. Provision the new container host
1. Run the pipeline and deploy to the container host
1. Cut over the DNS configuration to the container host
1. Test everything

I got started by writing a little script that builds an nginx container locally and mounts the generated hugo source directory. This is really just for sanity checking the nginx config and to ensure that everything docker related is working properly.

    #!/bin/bash
    hugo --cleanDestinationDir --baseURL http://localhost/
    chmod -R 777 public
    docker stop iflowfor8hours-nginx-sidecar
    docker rm -f iflowfor8hours-nginx-sidecar
    docker run --name iflowfor8hours-nginx-sidecar -v "$PWD"/public:/usr/share/nginx/html -v "$PWD"/dev/nginx.conf:/etc/nginx/nginx.conf:ro -p 80:80 nginx:alpine

It makes for an okay dev environment, but realistically `hugo serve` works just as well for such a simple application.

I next created the container that I will use in production. I didn't want to bake the letsencrypt stuff into the container because I wanted to keep each container as isolated as possible. Conceptually, containers should be more like processes than servers. I wrote a minimal `Dockerfile` first and built it by hand.

    FROM nginx:alpine
    COPY public /usr/share/nginx/html
    RUN chown -R nginx:nginx /usr/share/nginx/html
    COPY dev/nginx.conf /etc/nginx/nginx.conf
    
I then wrote the script for building the content and the container. I figured I might as well do this now, as the CI system will need some kind of entrypoint. This also helped me iterate quickly on my local box. 

    #!/bin/bash
    # Create a production and non-prod BASEURL environment variable in pipeline configuration

    if [ -z "${BASEURL}" ]; then 
        HUGO_BASEURL='http://localhost/'
    else 
        HUGO_BASEURL=${BASEURL}
    fi

    env HUGO_BASEURL=${HUGO_BASEURL} hugo --cleanDestinationDir
    docker build -t iflowfor8hours:blog .
    echo docker run --name bakedblog -p 80:80 iflowfor8hours:blog

This all worked fine locally, so I thought it would be a good idea to try kicking off a live staging environment. I wanted to try something new, and had read about surge.sh. I signed up and pointed my staging DNS [staging.iflowfor8hours.info](https://staging.iflowfor8hours.info) at [surge.sh](https://surge.sh), and deployed my work using their tools.

Surge is a service that hosts static web content and provides some tooling for deploying it from the command line. They built a really simple cli and don't charge you anything for the privilege. This was a great excuse to check them out, and it turns out that it does what it says on the tin. Everything I have tried works fine, although my use case is pretty simple. They charge for real SSL support, but this is just my staging environment so I don't really care about having a legit cert. All I had to do to deploy is below.

    hugo -v -b https://staging.iflowfor8hours.info -d staging -D 
    surge staging --domain https://staging.iflowfor8hours.info
    
It was dead simple, and I added it as a stage in my [codeship pipeline](https://app.codeship.com/projects/97531)

At this point, I thought it was time to provision my production environment. I did so using `docker-machine`. This allowed me to spin up a functional CoreOS box without much hassle. I like using CoreOS as a docker host since I believe it is just about as simple as it gets to use when trying to doing things with Docker.

    docker-machine create --driver=digitalocean \
    --digitalocean-access-token=ACCESS_TOKEN \
    --digitalocean-image=coreos-stable \
    --digitalocean-region=nyc3 \
    --digitalocean-size=512MB \  
    --digitalocean-ssh-user=core \
    iflowfor8hours-core

In the next entry, I'll deploy my site and the letsencrypt proxy to my container host, add the production deploy to to my pipeline.
