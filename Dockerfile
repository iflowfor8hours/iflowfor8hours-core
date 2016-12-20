FROM nginx:alpine
COPY public /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html
COPY dev/nginx-sec.conf /etc/nginx/nginx.conf
COPY keys/iflowfor8hours.info.key.pem  			/etc/ssl/key.pem
COPY keys/iflowfor8hours.info.fullchain.pem /etc/ssl/fullchain.pem
COPY keys/iflowfor8hours.info.csr.pem  			/etc/ssl/csr.pem
COPY keys/iflowfor8hours.info.dhparam.pem /etc/ssl/dhparam.pem

