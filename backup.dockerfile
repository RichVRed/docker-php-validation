# PACKAGE REPOSITORY: https://github.com/darh/php-essentials
# DOCKER REPOSITORY: https://hub.docker.com/r/darh/php-essentials/
FROM php:5.6.2-cli
MAINTAINER Richard Vannauker <richard.vannauker@gmail.com>
LABEL     org.label-schema.schema-version="1.0" \
          org.label-schema.build-date="$BUILD_DATE" \
          org.label-schema.version="$VERSION" \
          org.label-schema.name="" \
          org.label-schema.description="" \
          org.label-schema.vendor="SEOHEAT LLC" \
          org.label-schema.url="" \
          org.label-schema.vcs-ref="$VCS_REF" \
          org.label-schema.vcs-url="" \
          org.label-schema.usage="" \
          org.label-schema.docker.cmd="" \
          org.label-schema.docker.cmd.devel="" \
          org.label-schema.docker.cmd.test="" \
          org.label-schema.docker.cmd.debug="" \
          org.label-schema.docker.cmd.help="" \
          org.label-schema.docker.params="" \
          org.label-schema.rkt.cmd="" \
          org.label-schema.rkt.cmd.devel="" \
          org.label-schema.rkt.cmd.test="" \
          org.label-schema.rkt.cmd.debug="" \
          org.label-schema.rkt.cmd.help="" \
          org.label-schema.rkt.params="" \
          com.amazonaws.ecs.task-arn="" \
          com.amazonaws.ecs.container-name="" \
          com.amazonaws.ecs.task-definition-family="" \
          com.amazonaws.ecs.task-definition-version="" \
          com.amazonaws.ecs.cluster=""

RUN apt-get update && apt-get install -y libbz2-dev
RUN docker-php-ext-install bz2

RUN curl -O http://static.phpmd.org/php/2.1.3/phpmd.phar
RUN mv phpmd.phar /usr/local/bin/phpmd
RUN chmod +x /usr/local/bin/phpmd

RUN mkdir -p /workspace
WORKDIR /workspace
VOLUME /workspace

ENTRYPOINT ["phpmd"]


# PHP binary & extensions
RUN apt-get update
RUN apt-get install -y -q php5-cli=5.5.*
RUN apt-get install -y -q php5-curl php5-xdebug php5-readline php5-sqlite
RUN apt-get install -y -q php-pear

# Additional tools
ADD https://getcomposer.org/composer.phar                                          /usr/local/bin/composer
ADD https://phar.phpunit.de/phpunit.phar                                           /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpcpd.phar                                            /usr/local/bin/phpcpd
ADD https://phar.phpunit.de/phpdcd.phar                                            /usr/local/bin/phpdcd
ADD https://phar.phpunit.de/phploc.phar                                            /usr/local/bin/phploc
ADD https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar                         /usr/local/bin/phpcs
ADD https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar                        /usr/local/bin/phpcbf
ADD https://raw.github.com/Trismegiste/Mondrian/master/Resources/box/mondrian.phar /usr/local/bin/mondrian

# Make the tools executable
RUN cd /usr/local/bin && \
  chmod +x composer phpunit phpcpd phpdcd phploc phpcs phpcbf

RUN /usr/local/bin/composer global require \
	'pdepend/pdepend=1.1.*' \
	'phpmd/phpmd=1.4.*' \
	'behat/behat=2.4.*@stable'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

# Custom configuration
ADD essentials.ini /etc/php5/cli/conf.d/99-essentials.ini

CMD ["/usr/bin/php" , "-a"]


docker build  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
              --build-arg VCS_REF=`git rev-parse --short HEAD` \
              --build-arg VERSION=`cat VERSION` \
              --force-rm \
              --tag "rvannauker/pdepend" \
              --file pdepend.dockerfile .

docker build  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
              --build-arg VCS_REF=`git rev-parse --short HEAD` \
              --build-arg VERSION=`cat latest` \
              --force-rm \
              --tag "rvannauker/pdepend" \
              --file pdepend.dockerfile .