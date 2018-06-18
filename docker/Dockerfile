FROM registry.knotable.com:443/meteord-webapp-buildtime:1.6.0.1 as builder

LABEL to_remove=yes

ADD ./apm /app

RUN bash -cx "								        \
 export DEBIAN_FRONTEND=noninteractive           && \
 export METEOR_ALLOW_SUPERUSER=1                 && \
 export YARN_CACHE_FOLDER=/yarn_cache            && \
 export USER=root                                && \
 echo 'unsafe-perm = true' > /root/.npmrc        && \
 cd /app                                         && \
 rm -rf /app/.meteor/local                       && \
 yarn --prefer-offline --emoji --non-interactive && \
 meteor build --directory /tmp/the-app           && \
 mv /tmp/the-app/bundle /built_app               && \
 cd /built_app/programs/server/                  && \
 yarn --prefer-offline --emoji --non-interactive && \
 chmod -R 777 /built_app"

FROM registry.knotable.com:443/meteord-webapp-runtime:1.6.0.1

MAINTAINER Knotel

VOLUME /logs

ADD ./conf  /conf

COPY --from=builder /built_app  /built_app

CMD /conf/start_instance.sh
