FROM php:8.2-fpm

ARG PUID=1000
ARG PGID=1000

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    default-mysql-client \
    gosu \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mysqli \
    zip \
    gd \
    ftp \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${PGID} appgroup || true \
    && useradd -u ${PUID} -g ${PGID} -m -s /bin/bash appuser || true \
    && mkdir -p /var/www/tmp \
    && chown appuser:appgroup /var/www/tmp

RUN sed -i "s/user = www-data/user = appuser/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/group = www-data/group = appgroup/" /usr/local/etc/php-fpm.d/www.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY scripts /scripts
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /scripts/* /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]
