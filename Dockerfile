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
    php56w-bcmath \
    php56w-cli \
    php56w-common \
    php56w-devel \
    php56w-fpm \
    php56w-gd \
    php56w-imap \
    php56w-intl \
    php56w-mbstring \
    php56w-mcrypt \
    php56w-mssql \
    php56w-mysql \
    php56w-odbc \
    php56w-opcache \
    php56w-pdo \
    php56w-pear \
    php56w-pgsql \
    php56w-process \
    php56w-xml \
    php56w-pecl-imagick \
    php56w-pecl-redis \
    php56w-pecl-memcached \
    php56w-pecl-mongodb \
    composer \
    sudo \
    && mkdir -p /usr/download \
    && cd /usr/download \
    && wget -c http://nginx.org/download/nginx-1.17.9.tar.gz \
    && tar -zxvf nginx-1.17.9.tar.gz \
    && cd nginx-1.17.9 && sh ./configure --prefix=/usr/local/nginx \
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
