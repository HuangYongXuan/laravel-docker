FROM centos:7.4.1708
MAINTAINER linhan060604@qq.com
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y install gcc gcc-c++ git composer \
openssl openssl-devel \
zlib zlib-devel \
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
php72w-pecl-mongodb
RUN mkdir -p /usr/www/ \
    && cd /usr/www/ \
    && git clone https://754060604%40qq.com:Xuan5882@gitee.com/JiuMall/laravel-image-repertory.git repertory \
    && cd repertory/ \
    && cp .env.example .env \
    && composer install \
    && php artisan k:g
EXPOSE 8000

WORKDIR /usr/www/repertory
CMD php ./artisan serve --port=8000 --host=0.0.0.0

#CMD /start.sh
