FROM alpine:3.8

COPY docker /tmp/docker
ADD https://downloads.sourceforge.net/project/davmail/davmail/5.2.0/davmail-5.2.0-2961.zip /tmp/davmail/davmail.zip

RUN cd /tmp/davmail && unzip davmail.zip && rm davmail.zip && \
  install -dm755 /etc/davmail && \
  install -dm755 /usr/share/java/davmail/lib && \
  install -dm755 /var/log/davmail && \
  install -m644 davmail.jar /usr/share/java/davmail/davmail.jar && \
  install -m644 lib/* /usr/share/java/davmail/lib && \
  install -m755 /tmp/docker/davmail.sh /usr/share/java/davmail/davmail.sh && \
  install -m644 /tmp/docker/davmail.properties /etc/davmail/davmail.properties && \
  ln -s /usr/share/java/davmail/davmail.sh /usr/bin/davmail && \
  apk -U --no-progress upgrade && \
  apk --no-progress add openjdk8-jre-base && \
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
