+++
layout = "single"
title = "Building a containerized pipeline for this website"
date = "2016-12-09"
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

I now have a CoreOS box running at Digital Ocean, currently doing nothing. I have a locally built container with nginx and my content inside of it.

I get the following output when I run `docker-machine ls`

    NAME                  ACTIVE   DRIVER         STATE     URL                          SWARM   DOCKER    ERRORS
    iflowfor8hours-core   -        digitalocean   Running   tcp://159.203.119.101:2376           v1.11.2   
    
I first want to get this container running there and get and start figuring out what the pipeline would look like. I'm not following good CD principles by deploying different artifacts to [staging](https://staging.iflowfor8hours.info) and to [prod](https://iflowfor8hours.info). However it is a risk I'm willing to take in this case.

I created some DNS entries and then built and deployed my container. Everything worked fine, nothing exciting. I then spent a couple of hours trying to get letsencrypt to work the way I wanted it to and was ultimately met with defeat. Perhaps that is a battle for another day. I wound up using their great tool certbot to get my standalone certificates and then baking them into the build process of the docker container. Not exactly what I wanted, but this was taking longer than I thought and in the end didn't really provide a lot of value. All I had to do was run the following on my CoreOS host, and certificates came out.

    sudo docker run -it --rm -p 443:443 -p 80:80 --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    quay.io/letsencrypt/letsencrypt:latest certonly
    
I then switched up the build process a little bit and created an SSL-enabled config for NGINX.

I hit another unexpected snag at this point when I realized that [codeship](https://codeship.com/) (at least the way I'm using it) cannot deploy containers. The docker binaries are not in their build images, and I can't install it as we don't have root on them. All of the marketing on their website says they have a container platform, but I can't seem to get access to it. I'm redirected to the sign up link then right back into the interface I was just using, where there is no container platform. I'm sure it exists since there is so much documentation about it, but perhaps my account is too old or something. I contacted support and will deal with it later.

I looked at a few other build tools that I have used in the past like [snap-ci](https://snap-ci.com), [shippable](https://app.shippable.com/), and even [Heroku's](https://heroku.com) new-ish pipeline tool. I may do a comparison of tools later so I'll save the details, but the short story is that nothing fit the bill of simplicity and cost-free that I wanted.

So that wound up being the end of this. I now have a repo that can deploy to a staging environment automatically, can build and ship a container from my box or anyone elses, but no tool to run the full pipeline to my satisfaction. I'm going to have a look at gitlab and see if that has what I'm looking for.

The repo is on [Github](https://github.com/iflowfor8hours/iflowfor8hours.info) if anyone is interested. Feel free to contact me there if you have any bright ideas on what I'm looking for.
