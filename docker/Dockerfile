# FROM docker-registry.olbius.com/psql-jre8u281-9.5:1.0
#FROM docker-registry.olbius.com/psql:9.5.2
#FROM openjdk:8u275-jre-slim
FROM openjdk:11-jre
EXPOSE 8080 8443 5701

ENV MOQUI_HOME /opt/moqui

RUN mkdir -p $MOQUI_HOME/runtime
# RUN mkdir -p $MOQUI_HOME/tools

COPY docker-env.sh $MOQUI_HOME
# COPY elk.sh $MOQUI_HOME
# COPY tools/ $MOQUI_HOME/tools
RUN chmod +x $MOQUI_HOME/*.sh


COPY moqui/moqui.war $MOQUI_HOME
COPY moqui/runtime/ $MOQUI_HOME/runtime/

RUN rm -rf $MOQUI_HOME/runtime/conf
RUN rm -rf $MOQUI_HOME/runtime/db
RUN rm -rf $MOQUI_HOME/runtime/.git
RUN rm -f $MOQUI_HOME/runtime/.gitignore
RUN rm -rf $MOQUI_HOME/runtime/component/*/.git
RUN rm -f $MOQUI_HOME/runtime/component/*/.gitignore

COPY conf/ $MOQUI_HOME/runtime/conf/
COPY lib/ $MOQUI_HOME/runtime/lib/

RUN sed -i -e 's/\r$//'  $MOQUI_HOME/docker-env.sh

WORKDIR $MOQUI_HOME
CMD "./docker-env.sh"
