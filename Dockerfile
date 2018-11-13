FROM centos:7.4.1708
MAINTAINER 754060604@qq.com
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y install gcc gcc-c++ wget \
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
composer

RUN mkdir -p /usr/download \
cd /usr/download
RUN wget https://nginx.org/download/nginx-1.15.6.tar.gz
RUN tar -zxvf nginx-1.15.6.tar.gz
RUN cd nginx-1.15.6 && ls
RUN ./configure --help
RUN ./configure --prefix=/usr/local/nginx \
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
--with-http_auth_request_module
RUN make && make install
RUN mkdir -p /usr/www/public \
    && cd /usr/www/public
EXPOSE 8000 8002

VOLUME ["/usr/www"]

WORKDIR /usr/www
CMD php -S 0.0.0.0:8000 -t /usr/www/public

#CMD /start.sh
