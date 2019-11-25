FROM nginx:stable-alpine

ENV GCSPROXY_VERSION=0.3.0
ENV PUPPET_VERSION="6.11.1"
ENV FACTER_VERSION="3.14.5"

RUN apk add --no-cache --virtual .build-deps ca-certificates wget \
  && update-ca-certificates \
  && wget https://github.com/daichirata/gcsproxy/releases/download/v${GCSPROXY_VERSION}/gcsproxy_${GCSPROXY_VERSION}_amd64_linux -O /usr/local/bin/gcsproxy \
  && chmod +x /usr/local/bin/gcsproxy \
  && apk del .build-deps

RUN apk add --no-cache \
      ca-certificates \
      pciutils \
      ruby \
      ruby-irb \
      ruby-rdoc \
      && \
    echo http://dl-4.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk add --no-cache shadow && \
    gem install puppet:"$PUPPET_VERSION" facter:"$FACTER_VERSION" && \
    /usr/bin/puppet module install puppetlabs-apk

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
