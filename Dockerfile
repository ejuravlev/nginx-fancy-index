ARG DEBIAN_VERSION=11

FROM debian:${DEBIAN_VERSION}

ARG NGINX_VERSION=1.23.3

RUN apt update && \
    apt install -y  wget \
                    git \
                    gcc \
                    libssl-dev \
                    make \
                    libpcre3-dev \
                    zlib1g-dev \
                    libxml2-dev \
                    libxslt-dev \
                    libgd-dev \
                    libgeoip-dev \
                    libperl-dev && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    gunzip -c nginx-${NGINX_VERSION}.tar.gz | tar -xvf - && \
    git clone https://github.com/aperezdc/ngx-fancyindex.git ngx-fancyindex && \
    cd nginx-${NGINX_VERSION} && \
    ./configure \
        --add-module=../ngx-fancyindex \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \ 
        --http-log-path=/var/log/nginx/access.log && \
    make && make install && \
    apt remove -y wget \
                    git \
                    gcc \
                    libssl-dev \
                    make \
                    libpcre3-dev \
                    zlib1g-dev \
                    libxml2-dev \
                    libxslt-dev \
                    libgd-dev \
                    libgeoip-dev \
                    libperl-dev && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    cd .. && rm -rf nginx-* && rm -rf ngx-fancyindex

ENV PATH="${PATH}:/usr/local/nginx/sbin/"

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]