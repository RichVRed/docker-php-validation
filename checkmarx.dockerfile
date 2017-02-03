# BUILD:
# docker build --force-rm --tag "rvannauker/checkmarx" --file checkmarx.dockerfile .
# RUN:
# docker run -v ${PWD}:/usr/src --net=host "rvannauker/checkmarx:latest" Scan -CxServer http://checkmarx.na.directenergy.corp -ProjectName CxServer\\SP\\DirectEnergy\\Developers\\{projectName} -CxUser NADECORP\\{username} -CxPassword {password} -Incremental -LocationType Folder -LocationPath /usr/src -LocationPathExclude "vendor,coverage,phan" -v
# docker run -v ${PWD}:/usr/src --net=host "rvannauker/checkmarx:latest" Scan -CxServer http://checkmarx.na.directenergy.corp -ProjectName CxServer\\SP\\DirectEnergy\\Developers\\desharding -CxUser NADECORP\\RVannauker -CxPassword Test1234!  -LocationType Folder -LocationPath /usr/src -LocationPathExclude "vendor,coverage,phan,spec,docker" -Incremental -v
# PACKAGE: Checkmarx
# PACKAGE REPOSITORY: https://www.checkmarx.com/
# DESCRIPTION: A static analysis engine
FROM openjdk:latest
MAINTAINER Richard Vannauker <richard.vannauker@gmail.com>
# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
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

VOLUME /usr/src
VOLUME /usr/output
WORKDIR /usr/src

ARG CHECKMARX_CxSAST_ENTERPRISE_URL="https://download.checkmarx.net/8.4.1/CxSAST.841.Release.Setup_8.4.1.199.zip"
ARG CHECKMARK_CX_CLI_URL="http://download.checkmarx.com/8.2.0/Plugins/CxConsolePlugin-CLI-7.5.0.3.zip"

ADD ${CHECKMARK_CX_CLI_URL} /tmp/cli.zip

RUN  mkdir -p /opt/CxConsolePlugin && \
  unzip /tmp/cli.zip -d /tmp && \
  mv /tmp/CxConsolePlugin-7.5.0-20160719-1414/* /opt/CxConsolePlugin && \
  rm -rf /tmp/cli.zip && \
  rm -rf /tmp/CxConsolePlugin-7.5.0-20160719-1414 && \
  chmod +x /opt/CxConsolePlugin/runCxConsole.sh

ENTRYPOINT ["/opt/CxConsolePlugin/runCxConsole.sh"]

# 1. convert to alpine
# 2. install jdk9
# 3. xml output to version one backlog items/tasks ( do not repeat)
#   b. optional close/remove if not found
# 4. each be a different board based on app

# 5. feed stats of phploc into grafana on a per commit basis for tracking
# 6. feed stats of Checkmarx into grafana for tracking
# 7. examine other static anaylsis things to determine other metrics to feed into grafana
# 8. version results file by timestamp and do diff comparison to determine new results