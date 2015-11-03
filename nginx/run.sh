#!/bin/sh

# sed -i -e "s/%restapihost%/$RESTAPI_PORT_8080_TCP_ADDR/g" /etc/nginx/nginx.conf
# sed -i -e "s/%restapiport%/$RESTAPI_PORT_8080_TCP_PORT/g" /etc/nginx/nginx.conf
sed -i -e "s/%rstudiohost%/$RSTUDIO_PORT_8080_TCP_ADDR/g" /etc/nginx/nginx.conf
sed -i -e "s/%rstudioport%/$RSTUDIO_PORT_8080_TCP_PORT/g" /etc/nginx/nginx.conf
sed -i -e "s/%stormuihost%/$STORMUI_PORT_8080_TCP_ADDR/g" /etc/nginx/nginx.conf
sed -i -e "s/%stormuiport%/$STORMUI_PORT_8080_TCP_PORT/g" /etc/nginx/nginx.conf

# start nginx
service nginx start
