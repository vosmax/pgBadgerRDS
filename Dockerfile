FROM python:3.7.3-alpine3.9

MAINTAINER VMax <https://github.com/vosmax>

ENV AWS_CLI_VERSION 1.16.157
ENV PGBADGER_VERSION 10.3
ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION ""
ENV AWS_RDS_INSTANCE_NAME ""
ENV AWS_BUCKET_NAME ""

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk --no-cache update && \
    apk --no-cache add ca-certificates groff less bash coreutils perl && \
    apk --no-cache add --virtual build-deps tar wget make && \
    pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} && \
    rm -rf /var/cache/apk/* && \ 
    #Do this tricky to escape https://nvd.nist.gov/vuln/detail/CVE-2016-4074 
    wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x jq-linux64 && \
    mv jq-linux64 /usr/bin/jq && \
    chmod +x docker-entrypoint.sh

RUN mkdir /source && \
    cd /source && \
    wget --no-check-certificate https://github.com/darold/pgbadger/archive/v${PGBADGER_VERSION}.tar.gz && \
    tar xzf v${PGBADGER_VERSION}.tar.gz && \
    cd pgbadger-${PGBADGER_VERSION} && \
    perl Makefile.PL && make && make install && \
    rm -R /source && \
    apk del build-deps

ENTRYPOINT ["./docker-entrypoint.sh"]