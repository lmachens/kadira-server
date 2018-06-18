FROM knotel/meteord-webapp-buildtime:1.6.1.1 as builder

MAINTAINER Knotel

LABEL to_remove=yes

ADD ./apm /app

RUN bash -cx "                                      \
 export DEBIAN_FRONTEND=noninteractive           && \
 export METEOR_ALLOW_SUPERUSER=1                 && \
 export YARN_CACHE_FOLDER=/yarn_cache            && \
 export USER=root                                && \
 echo 'unsafe-perm = true' > /root/.npmrc        && \
 cd /app                                         && \
 rm -rf /app/.meteor/local                       && \
 yarn --prefer-offline --emoji --non-interactive && \
 meteor build --directory /tmp/the-app            ; \
 meteor build --directory /tmp/the-app           && \
 mv /tmp/the-app/bundle /built_app               && \
 cd /built_app/programs/server/                  && \
 yarn --prefer-offline --emoji --non-interactive && \
 chmod -R 777 /built_app                         && \
 rm -rf /tmp/the-app                             && \
 rm -rf /app/node_modules"

# Have to repeat building as the first 'meteor build' gives:
#
#    Errors prevented bundling:                    
#    While processing files with less (for target web.browser):
#    client/0config/bootstrap/custom.bootstrap.import.less:6: 
#    Unknown import: custom.bootstrap.mixins.import.less
#
# But running 'meteor build' again after that gives no errors
# as compileLessBatch successfully creates needed files during first run.

FROM knotel/meteord-webapp-runtime:1.6.1.1

MAINTAINER Knotel

VOLUME /logs

ADD ./docker/meteor-apm-server/conf  /conf

COPY --from=builder /built_app  /built_app

CMD /conf/start_instance.sh
