FROM ubuntu

MAINTAINER Patrick Wiener "patrick.wiener@hs-karlsruhe.de"

RUN apt-get update && \
    apt-get install -y nginx

RUN rm -v /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/proxy_conf /etc/nginx/conf.d/proxy_conf
ADD auth/.htpasswd /etc/nginx/.htpasswd
ADD certs/server.crt /etc/nginx/certs/server.crt
ADD certs/server.key /etc/nginx/certs/server.key
ADD run.sh /etc/nginx/run.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["/bin/bash","/etc/nginx/run.sh"]
