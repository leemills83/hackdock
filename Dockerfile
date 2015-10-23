FROM ubuntu:14.04

MAINTAINER Lee Mills <l.mills@me.com>

# Install.
RUN \
    sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential && \
    apt-get install -y software-properties-common && \
    apt-get install -y byobu curl git htop man unzip vim wget && \
    apt-get install -y nginx && \
    apt-get install -y nodejs && \
    apt-get install -y npm && \
    apt-get install -y couchdb && \
    rm -rf /var/lib/apt/lists/*

# Create webroot
RUN mkdir /srv/www
ADD ./index.html /srv/www/index.html

# Replace the stock config with a nicer one.
RUN rm -rf /etc/nginx

# Unfortunately, because of a bug in hub.docker.com,
# we can't use Git submodules here to drop modules in.
RUN cd /tmp && \
  curl -L -o server-configs-nginx.zip https://github.com/h5bp/server-configs-nginx/archive/master.zip && \
  unzip server-configs-nginx.zip && \
  mv server-configs-nginx-master /etc/nginx

RUN mkdir /etc/nginx/conf
RUN sed -ri 's/user www www;/user nginx nginx;\n\n# Run Nginx in the foreground for Docker.\ndaemon off;/g' /etc/nginx/nginx.conf
RUN sed -ri 's/logs\/error.log/\/var\/log\/nginx\/error.log/g' /etc/nginx/nginx.conf
RUN sed -ri 's/logs\/access.log/\/var\/log\/nginx\/access.log/g' /etc/nginx/nginx.conf
RUN sed -ri 's/logs\/static.log/\/var\/log\/nginx\/static.log/g' /etc/nginx/h5bp/location/expires.conf

# Don't run Nginx as a daemon. This lets the docker host monitor the process.
RUN ln -s /etc/nginx/sites-available/no-default /etc/nginx/sites-enabled

EXPOSE 80 22

ADD scripts /scripts
RUN chmod +x /scripts/start.sh

# Expose our web root and log directories log.
VOLUME ["/vagrant", "/srv/www", "/var/log", "/var/run"]

# Kicking in
CMD ["/scripts/start.sh"]
