FROM linuxkit/ca-certificates:v0.6 AS ca-certificates

FROM    golang:1.12rc1-alpine AS build
ENV     CGO_ENABLED 0
RUN     apk add --no-cache git
RUN     git clone https://github.com/nytimes/gcs-helper.git /code
WORKDIR /code
RUN     go install

FROM nginx:stable-alpine

ENV PUPPET_VERSION="6.15.0"
ENV FACTER_VERSION="3.14.10"
ENV CACHE_MAX_SIZE="1g"
ENV CACHE_INACTIVE="1h"

COPY --from=build /go/bin/gcs-helper /usr/bin/gcs-helper
COPY --from=ca-certificates / /

ADD nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/*
ADD proxy.conf /etc/nginx/conf.d/proxy.conf

RUN apk add --no-cache ca-certificates pciutils ruby ruby-irb ruby-rdoc
RUN echo http://dl-4.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk add --no-cache shadow
RUN gem install puppet:"$PUPPET_VERSION" facter:"$FACTER_VERSION"
RUN /usr/bin/puppet module install puppetlabs-apk

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 80
EXPOSE 443

VOLUME [ "/cache", "/log" ]

CMD ["/run.sh"]
