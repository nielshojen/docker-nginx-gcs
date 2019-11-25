FROM nginx:stable-alpine

ENV GCSPROXY_VERSION=0.3.0
RUN apk add --no-cache --virtual .build-deps ca-certificates wget \
  && update-ca-certificates \
  && wget https://github.com/daichirata/gcsproxy/releases/download/v${GCSPROXY_VERSION}/gcsproxy_${GCSPROXY_VERSION}_amd64_linux -O /usr/local/bin/gcsproxy \
  && chmod +x /usr/local/bin/gcsproxy \
  && apk del .build-deps

ADD nginx.conf /etc/nginx/conf.d/default.conf

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 80
EXPOSE 443

CMD ["/run.sh"]