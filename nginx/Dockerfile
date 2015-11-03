FROM ubuntu

MAINTAINER Patrick Wiener "patrick.wiener@hs-karlsruhe.de"

RUN apt-get update
RUN apt-get install -y nano net-tools
RUN apt-get install -y nginx

RUN rm -v /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/proxy_conf /etc/nginx/conf.d/proxy_conf
ADD auth/.htpasswd /etc/nginx/.htpasswd
ADD certs/server.crt /etc/nginx/certs/server.crt
ADD certs/server.key /etc/nginx/certs/server.key
ADD run.sh /etc/nginx/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["run.sh"]
