FROM registry.knotable.com:443/knotel-ubuntu:16.04
MAINTAINER Knotel

VOLUME /logs

# Install base
RUN bash -cx "                                              \
 export DEBIAN_FRONTEND=noninteractive                   && \
 apt-get update -y                                       && \
 apt-get install -y curl python build-essential          && \
 curl https://install.meteor.com/?release=1.4.3.2 | sh   && \
 apt autoremove -y                                       && \
 apt-get clean                                           && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*              \
 "

COPY kadira-ui/ app/

#CMD ["/app/run.sh"]


#export METEOR_ALLOW_SUPERUSER=1
#cd /app
#meteor npm install --production
#meteor build --directory /tmp/the-app
#rm -rf /app/.meteor/local
#cd /tmp/the-app/bundle/programs/server/
#meteor npm install --save
#cd /
#mv /tmp/the-app/bundle /built_app
#cd /built_app
#chmod -R 777 .
#rm -rf /tmp/the-app
#rm -rf /app/node_modules
