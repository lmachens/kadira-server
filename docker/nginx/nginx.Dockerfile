FROM ubuntu:16.04
MAINTAINER Knotel

# Install Nginx.
RUN bash -cx "                                                                \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C        && \
  echo 'deb http://ppa.launchpad.net/nginx/stable/ubuntu xenial main' >       \
                                    /etc/apt/sources.list.d/nginx.list     && \
  apt-get update                                                           && \
  apt-get install -y nginx apache2-utils                                   && \
  apt-get autoremove -y                                                    && \
  apt-get clean                                                            && \
  rm -rf /var/lib/apt/lists/*                                              && \
  chown -R www-data:www-data /var/lib/nginx                                && \
  rm -rf /etc/nginx/sites-enabled /var/www/html                            && \
  mkdir -p /logs                                                              \
  "

# Define working directory.
WORKDIR /etc/nginx

COPY conf/ /etc/nginx/
VOLUME /logs

EXPOSE 80
EXPOSE 443
EXPOSE 11001
EXPOSE 7017

CMD nginx -g "daemon off;"
