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

# Install forever
RUN \
 npm install -g forever

COPY kadira-alertsman/ app/

RUN cd /app && yarn install

CMD ["/app/run.sh"]
