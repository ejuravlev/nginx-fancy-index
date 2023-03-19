ARG ALPINE_VERSION=3.17

FROM alpine:${ALPINE_VERSION}

ARG NGINX_VERSION=1.22.1

WORKDIR /build

RUN apk update && \
    apk add --no-cache wget gzip linux-headers \
                       openssl-dev pcre2-dev zlib-dev openssl abuild \
                        musl-dev libxslt libxml2-utils make mercurial  \
                        gcc unzip git xz g++ coreutils && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    gunzip -c nginx-${NGINX_VERSION}.tar.gz | tar -xvf - && \
    git clone https://github.com/aperezdc/ngx-fancyindex.git ngx-fancyindex && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --add-module=../ngx-fancyindex && \
    make && make install && \
    apk del wget gzip linux-headers \
            openssl-dev pcre2-dev zlib-dev openssl abuild \
            musl-dev libxslt libxml2-utils make mercurial  \
            gcc unzip git xz g++ coreutils && \
    rm -rf /var/cache/apk/* && \
    rm -rf /build
