# BUILD:
# sudo docker build --force-rm --tag "rvannauker/pdepend" --file pdepend.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="pdepend" "rvannauker/pdepend" {destination}
# PACKAGE: PHP_Depend
# PACKAGE REPOSITORY: https://github.com/pdepend/pdepend.git
# DESCRIPTION: This tool shows you the quality of your design in the terms of extensibility, reusability and maintainability.
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
           php5-ctype \
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'pdepend/pdepend=2.5.0'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["pdepend"]