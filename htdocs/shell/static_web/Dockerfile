# Version: 0.0.1
FROM debian:stretch
MAINTAINER upperyounger "upperyounger@outlook.com"
ENV REFRESHED_AT 2018-10-03
RUN apt-get update
RUN apt-get install -y nginx
RUN echo 'Hi, I an in your container' \
    >/usr/share/nginx/html/index.html
EXPOSE 80

