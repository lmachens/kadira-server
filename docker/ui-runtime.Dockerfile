FROM registry.knotable.com:443/knotel-ubuntu:16.04

MAINTAINER Knotel

VOLUME /logs

# Install base and node.js and required npm packages
RUN   \
      apt-get update -y                                                       && \
      apt-get install -y                                                         \
      curl python build-essential                                             && \
# Install Node.js version corresponding to Meteor version
      export NODE_VERSION=4.8.0                                               && \
      export NODE_ARCH=x64                                                    && \
      export NODE_DIST=node-v${NODE_VERSION}-linux-${NODE_ARCH}               && \
      cd /tmp                                                                 && \
      curl -O -L http://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.gz  && \
      tar xvzf ${NODE_DIST}.tar.gz                                            && \
      rm -rf /opt/nodejs                                                      && \
      mv ${NODE_DIST} /opt/nodejs                                             && \
      ln -sf /opt/nodejs/bin/node /usr/bin/node                               && \
      ln -sf /opt/nodejs/bin/npm /usr/bin/npm                                 && \
      npm install -g forever node-gyp ejson fibers                            && \
      apt-get remove -y curl python build-essential                           && \
      apt autoremove -y                                                       && \
      apt-get clean                                                           && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
