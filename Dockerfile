FROM linuxkit/ca-certificates:v0.6 AS ca-certificates

FROM    golang:1.12rc1-alpine AS build
ENV     CGO_ENABLED 0
RUN     apk add --no-cache git
RUN     git clone https://github.com/nytimes/gcs-helper.git /code
WORKDIR /code
RUN     go install

FROM nginx:stable-alpine

ENV CACHE_MAX_SIZE="1g"
ENV CACHE_INACTIVE="1h"

COPY --from=build /go/bin/gcs-helper /usr/bin/gcs-helper
COPY --from=ca-certificates / /

ADD nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/*
ADD proxy.conf /etc/nginx/conf.d/proxy.conf

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 80

VOLUME [ "/cache", "/log" ]

CMD ["/run.sh"]
