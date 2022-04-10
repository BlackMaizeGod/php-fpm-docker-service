ARG PHP_VERSION

FROM chialab/php-dev:${PHP_VERSION}-fpm

# Install mhsendmail - Sendmail replacement for Mailhog
RUN curl -Lsf 'https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf - ; \
    /usr/local/go/bin/go get github.com/mailhog/mhsendmail ; \
    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail ; \
    echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' > /usr/local/etc/php/conf.d/docker-ext-mhsendmail.ini

# Configure Xdebug
RUN echo '' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.mode=debug' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.log=/dev/null' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Configure PHP-FPM service
RUN echo 'listen.owner = www-data' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'listen.group = www-data' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'listen.mode = 0660' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'pm = dynamic' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'pm.max_children = 5' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'pm.start_servers = 2' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'pm.min_spare_servers = 1' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'pm.max_spare_servers = 3' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo '' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'user = 1000' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'group = 1000' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo '' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'catch_workers_output = no' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_admin_flag[log_errors] = off' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_admin_flag[display_errors] = off' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_admin_value[error_log] = /dev/null' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'access.log = /dev/null' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_value[memory_limit] = 512M' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_value[post_max_size] = 24M' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'php_value[upload_max_filesize] = 24M' >> /usr/local/etc/php-fpm.d/zz-docker.conf
