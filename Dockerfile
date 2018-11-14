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
RUN yum install -y sudo
RUN mkdir -p /usr/download \
cd /usr/download
RUN wget -c https://nginx.org/download/nginx-1.15.6.tar.gz
RUN tar -zxvf nginx-1.15.6.tar.gz
RUN cd nginx-1.15.6 && sh ./configure --prefix=/usr/local/nginx \
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
 && make && make install
RUN mkdir -p /usr/www/public \
    && cd /usr/www/public

RUN groupadd nginx
RUN useradd -g nginx -M nginx -s /sbin/nologin
COPY ./index.php /usr/www/public
RUN rm -rf /etc/nginx/nginx.conf
COPY ./nginx.conf /etc/nginx
WORKDIR /usr/www
#COPY ./entrypoint.sh /usr/sbin
#RUN chmod 755 /usr/sbin/entrypoint.sh

COPY ./php-fpm /etc/init.d
RUN chmod 755 /etc/init.d/php-fpm;
RUN yum install initscripts -y;
RUN  chkconfig --add /etc/init.d/php-fpm && service php-fpm start && chkconfig php-fpm on && systemctl enable php-fpm.service

EXPOSE 8000
VOLUME ["/usr/www"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
