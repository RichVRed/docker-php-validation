# BUILD:
# sudo docker build --force-rm --tag "richvred/php-reaper:latest" --file php-reaper.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="php-reaper" "richvred/php-reaper:latest" -d {destination}
# PACKAGE: PHP-Reaper
# PACKAGE REPOSITORY: https://github.com/emanuil/php-reaper
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@directenergy.com>

# PHP binary & extensions
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           php5 \
           git \
    && rm -rf /var/cache/apk/*

# Additional tools
RUN git clone https://github.com/emanuil/php-reaper /usr/local/bin/php-reaper

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/php-reaper/php-reaper.php"]