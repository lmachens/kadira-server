FROM registry.knotable.com:443/knotel-ubuntu:16.04
MAINTAINER Knotel

VOLUME /logs

# Install base
RUN \
 export DEBIAN_FRONTEND=noninteractive                   && \
 apt-get update -y                                       && \
 apt-get install -y                                         \
 curl git python-minimal build-essential                    \
 apt-transport-https lsb-release                         && \
# Install Node.js LTS and yarn
 curl -sL https://deb.nodesource.com/setup_8.x |            \
                                          bash -         && \
 curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |        \
                                       apt-key add -     && \
 echo "deb https://dl.yarnpkg.com/debian/ stable main" |    \
         tee /etc/apt/sources.list.d/yarn.list           && \
 apt-get update -y                                       && \
 apt-get install -y nodejs yarn                          && \
 apt autoremove -y                                       && \
 apt-get clean                                           && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install MongoDB shell
RUN \
 export DEBIAN_FRONTEND=noninteractive                   && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80      \
       --recv 0C49F3730359A14518585931BC711F9BA15703C6   && \
 echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | \
 tee /etc/apt/sources.list.d/mongodb-org-3.4.list        && \
 apt-get update -y                                       && \
 apt-get install -y mongodb-org-shell

COPY kadira-rma/ app/

CMD ["/app/run.sh"]
