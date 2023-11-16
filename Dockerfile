ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ARG DAVMAIL_VERSION
ARG DAVMAIL_REVISION
ADD https://sourceforge.net/projects/davmail/files/davmail/${DAVMAIL_VERSION}/davmail-${DAVMAIL_VERSION}-${DAVMAIL_REVISION}.zip/download /tmp/davmail/davmail.zip
COPY .circleci/container /tmp/container

RUN cd /tmp/davmail && unzip davmail.zip && rm davmail.zip && \
  install -dm755 /etc/davmail && \
  install -dm755 /usr/share/java/davmail/lib && \
  install -dm755 /var/log/davmail && \
  install -m644 davmail.jar /usr/share/java/davmail/davmail.jar && \
  install -m644 lib/* /usr/share/java/davmail/lib && \
  install -m755 /tmp/container/davmail.sh /usr/share/java/davmail/davmail.sh && \
  install -m644 /tmp/container/davmail.properties /etc/davmail/davmail.properties && \
  ln -s /usr/share/java/davmail/davmail.sh /usr/bin/davmail && \
  apk -U --no-progress upgrade && \
  apk --no-progress add openjdk8-jre-base nss && \
  adduser -S -D -H -h / -s /sbin/nologin -G users -g davmail davmail && \
  chown davmail:users /var/log/davmail && \
  rm -rf /root/.ash_history /root/.cache /tmp/* /var/cache/apk/*

EXPOSE 1080
EXPOSE 1143
EXPOSE 1389
EXPOSE 1110
EXPOSE 1025
USER davmail
ENTRYPOINT [ "/usr/bin/davmail", "/etc/davmail/davmail.properties" ]
