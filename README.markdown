Blog at iflowfor8hours.info
=====

[ ![Codeship Status for iflowfor8hours/arcadian-adventure](https://app.codeship.com/projects/71edf360-27ef-0133-7378-3ef19dc5f2fb/status?branch=master)](https://app.codeship.com/projects/97531)

This is my personal blog, generated with [hugo](https://gohugo.io/). Hosted on digital ocean.


Building
--------

`hugo`

Deployment
----------

Codeship does it:

    wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz
    tar xzf ${HUGO_BINARY}.tar.gz -C ~/bin/
    ln -s ~/bin/${HUGO_BINARY}/${HUGO_BINARY} ~/bin/hugo
    hugo
    rsync --delete -ravz -e "ssh" ~/clone/public/ www-data@192.34.62.103:/var/www/iflowfor8hours.info



TODO
---------

3  environments:
  test.iflowfor8hours.info test = gh-pages 
  staging.iflowfor8hours.info = surge.sh
  iflowfor8hours.info = 

~~Docker deployment~~
Deploy consistently?
Host a mirror on gh-pages
