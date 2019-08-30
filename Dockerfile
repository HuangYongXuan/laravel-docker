FROM centos:latest
MAINTAINER 754060604@qq.com

COPY index.php nginx.conf run.sh supervisord.conf /

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum -y install gcc gcc-c++ wget supervisor \
    pcre pcre-devel \
    zlib zlib-devel \
    openssl openssl-devel \
    php72w-bcmath \
    php72w-xml \
    php72w-gd \
    php72w-cli \
    php72w-fpm \
    php72w-pear \
    php72w-mysqlnd \
    php72w-devel \
    php72w-mcrypt \
    php72w-mbstring \
    php72w-common \
    php72w-process \
    php72w-pdo \
    php72w-opcache \
    php72w-intl \
    php72w-pgsql \
    php72w-pecl-imagick \
    php72w-pecl-redis \
    php72w-pecl-memcached \
    php72w-pecl-mongodb \
    composer \
    sudo \
    && mkdir -p /usr/download \
    && cd /usr/download \
    && wget -c http://nginx.org/download/nginx-1.17.3.tar.gz \
    && tar -zxvf nginx-1.17.3.tar.gz \
    && cd nginx-1.17.3 && sh ./configure --prefix=/usr/local/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-pcre \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
         && make && make install \
    && mkdir -p /usr/www/public \
    && cd /usr/www/public \
    && groupadd nginx \
    && useradd -g nginx -M nginx -s /sbin/nologin \
    && rm -rf /etc/nginx/nginx.conf \
    && chmod +x /run.sh \
    && cp /index.php /usr/www/public \
    && cp /nginx.conf /etc/nginx \
    && rm -rf /etc/supervisord.conf \
    && cp /supervisord.conf /etc \
    && rm -rf /usr/download \
    && yum clean all \
    && mkdir -p /usr/local/nginx/logs/ \
    && yum remove -y gcc gcc-c++ wget pcre-devel zlib-devel openssl openssl-devel sudo

WORKDIR /usr/www
EXPOSE 8000
VOLUME ["/usr/www"]

ENTRYPOINT /run.sh
