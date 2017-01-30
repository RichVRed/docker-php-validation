# BUILD:
# sudo docker build --force-rm --tag "rvannauker/php-coupling-detector:latest" --file php-coupling-detector.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="php-coupling-detector" "rvannauker/php-coupling-detector:latest" detect {destination} --config-file=.php_cd --format=dot
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@directenergy.com>

# PHP binary & extensions
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           php5 \
           php5-json \
           php5-openssl \
           php5-phar \
           php5-dom \
           git \
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'akeneo/php-coupling-detector=1.0.x-dev'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["php-coupling-detector"]