# BUILD:
# sudo docker build --force-rm --tag "richvred/phpca:latest" --file phpca.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phpca" "richvred/phpca:latest" --no-progress {destination}
# PACKAGE: PhpCodeAnalyzer
# PACKAGE REPOSITORY: https://github.com/wapmorgan/PhpCodeAnalyzer
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
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
          'docopt/docopt=1.0.0-rc1' \
	      'wapmorgan/php-code-analyzer=1.0.1'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["phpca"]