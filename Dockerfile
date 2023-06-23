FROM alpine:latest

ARG LUFI_VERSION=master

ENV GID=991 \
    UID=991 \
    LUFI_DIR=/usr/lufi

LABEL description="lufi on alpine" \
      maintainer="Stefan Bellon <https://github.com/sbellon>"

RUN apk add --update --no-cache --virtual .build-deps \
                build-base \
                libressl-dev \
                ca-certificates \
                tar \
                perl-dev \
                libidn-dev \
                wget \
    && apk add --update --no-cache \
                libressl \
                perl \
                libidn \
                perl-crypt-rijndael \
                perl-test-manifest \
                perl-net-ssleay \
                tini \
                su-exec \
                git \
                curl \
    && echo | cpan \
    && cpan install CPAN \
    && cpan reload CPAN \
    && cpan install Carton \
    && git clone -b ${LUFI_VERSION} https://framagit.org/fiat-tux/hat-softwares/lufi ${LUFI_DIR} \
    && cd ${LUFI_DIR} \
    && sed -i -e "s/requires 'Mojolicious'.*/requires 'Mojolicious', '>= 8.05, < 9.11';/" cpanfile \
    && rm cpanfile.snapshot \
    && carton install --without=test --without=swift-storage --without=ldap --without=postgresql --without=mysql --without=htpasswd \
    && carton install --deployment --without=test --without=swift-storage --without=ldap --without=postgresql --without=mysql --without=htpasswd \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /root/.cpan* ${LUFI_DIR}/local/cache/*

WORKDIR ${LUFI_DIR}
VOLUME ${LUFI_DIR}/data ${LUFI_DIR}/files
EXPOSE 8081

COPY startup /usr/local/bin/startup
COPY lufi.conf.template ${LUFI_DIR}/lufi.conf.template
RUN chmod +x /usr/local/bin/startup

HEALTHCHECK CMD curl --silent --head --fail http://127.0.0.1:8081/ || exit 1

CMD ["/usr/local/bin/startup"]
