# BUILD:
# sudo docker build --force-rm --tag "richvred/php-formatter:latest" --file php-formatter.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="php-formatter" "richvred/php-formatter:latest" formatter:use:sort {destination}
# sudo docker run --rm --volume $(pwd):/workspace --name="php-formatter" "richvred/php-formatter:latest" formatter:strict:fix {destination}
# sudo docker run --rm --volume $(pwd):/workspace --name="php-formatter" "richvred/php-formatter:latest" formatter:header:fix {destination}
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@directenergy.com>

# PHP binary & extensions
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           php7 \
           php7-json \
           php7-openssl \
           php7-phar \
           php7-libsodium \
           php7-mbstring \
           php7-ctype \
           git \
    && rm -rf /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'mmoreram/php-formatter=dev-master'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["php-formatter"]