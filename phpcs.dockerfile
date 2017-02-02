# BUILD:
# sudo docker build --force-rm --tag "rvannauker/phpcs" --file phpcs.dockerfile .
# SUGGESTED BUILD:
# sudo docker build --force-rm --build-arg COLORS=1 --build-arg SHOW_PROGRESS=1 --build-arg REPORT_WIDTH=140 --build-arg ENCODING=utf-8 --build-arg REPORT_FORMAT=full --tag "rvannauker/phpcs" --file phpcs.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phpcs" "rvannauker/phpcs" --config-set colors=1 --standard="PSR2" -v {destination}
# PACKAGE: PHP_CodeSniffer
# PACKAGE REPOSITORY: https://github.com/squizlabs/PHP_CodeSniffer
# DESCRIPTION: PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards.
# CONFIGURATION: https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options
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
           php5-ctype \
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'squizlabs/php_codesniffer=2.7.1'

# Add path to composed tools and set other environment variables
ARG PATH=/root/.composer/vendor/bin:$PATH
ARG COLORS=0
ARG DEFAULT_STANDARD=PSR2
ARG ENCODING=''
ARG ERROR_SEVERITY=''
ARG IGNORE_ERRORS_ON_EXIT=''
ARG IGNORE_WARNINGS_ON_EXIT=''
ARG INSTALLED_PATHS=''
ARG REPORT_FORMAT=summary
ARG REPORT_WIDTH=120
ARG SEVERITY=''
ARG SHOW_PROGRESS=1
ARG SHOW_WARNINGS=0
ARG TAB_WIDTH=''
ARG WARNING_SEVERITY=''

ENV PATH=/root/.composer/vendor/bin:$PATH \
    COLORS=${COLORS:-0} \
    DEFAULT_STANDARD=${DEFAULT_STANDARD:-PSR2} \
    ENCODING=${ENCODING} \
    ERROR_SEVERITY=${ERROR_SEVERITY} \
    IGNORE_ERRORS_ON_EXIT=${IGNORE_ERRORS_ON_EXIT} \
    IGNORE_WARNINGS_ON_EXIT=${IGNORE_WARNINGS_ON_EXIT} \
    INSTALLED_PATHS=${INSTALLED_PATHS} \
    REPORT_FORMAT=${REPORT_FORMAT:-summary} \
    REPORT_WIDTH=${REPORT_WIDTH:-120} \
    SEVERITY=${SEVERITY} \
    SHOW_PROGRESS=${SHOW_PROGRESS:-1} \
    SHOW_WARNINGS=${SHOW_PROGRESS:-0} \
    TAB_WIDTH=${TAB_WIDTH} \
    WARNING_SEVERITY=${WARNING_SEVERITY}


RUN /root/.composer/vendor/bin/phpcs --config-set colors ${COLORS} && \
    /root/.composer/vendor/bin/phpcs --config-set default_standard ${DEFAULT_STANDARD} && \
    /root/.composer/vendor/bin/phpcs --config-set encoding ${ENCODING} && \
    /root/.composer/vendor/bin/phpcs --config-set error_severity ${ERROR_SEVERITY} && \
    /root/.composer/vendor/bin/phpcs --config-set ignore_errors_on_exit ${IGNORE_ERRORS_ON_EXIT} && \
    /root/.composer/vendor/bin/phpcs --config-set ignore_warnings_on_exit ${IGNORE_WARNINGS_ON_EXIT} && \
    /root/.composer/vendor/bin/phpcs --config-set installed_paths ${INSTALLED_PATHS} && \
    /root/.composer/vendor/bin/phpcs --config-set report_format ${REPORT_FORMAT} && \
    /root/.composer/vendor/bin/phpcs --config-set report_width ${REPORT_WIDTH} && \
    /root/.composer/vendor/bin/phpcs --config-set severity ${SEVERITY} && \
    /root/.composer/vendor/bin/phpcs --config-set show_progress ${SHOW_PROGRESS} && \
    /root/.composer/vendor/bin/phpcs --config-set show_warnings ${SHOW_WARNINGS} && \
    /root/.composer/vendor/bin/phpcs --config-set tab_width ${TAB_WIDTH} && \
    /root/.composer/vendor/bin/phpcs --config-set warning_severity ${WARNING_SEVERITY}

#    /root/.composer/vendor/bin/phpcs --config-set csslint_path /path/to/csslint && \
#    /root/.composer/vendor/bin/phpcs --config-set gjslint_path /path/to/gjslint && \
#
#    /root/.composer/vendor/bin/phpcs --config-set rhino_path /path/to/rhino && \
#    /root/.composer/vendor/bin/phpcs --config-set jshint_path /path/to/jshint.js && \
#    /root/.composer/vendor/bin/phpcs --config-set jslint_path /path/to/jslint.js && \
#
#    /root/.composer/vendor/bin/phpcs --config-set jsl_path /path/to/jsl && \
#    /root/.composer/vendor/bin/phpcs --config-set zend_ca_path /path/to/ZendCodeAnalyzer


RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["phpcs"]