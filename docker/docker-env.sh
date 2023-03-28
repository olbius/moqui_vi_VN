#!/bin/sh
set -e

export PATH=$JAVA_HOME/bin:$PATH

java $JAVA_OPTS -jar /opt/moqui/moqui.war conf=/opt/moqui/runtime/conf/MoquiProductionConf.xml threads=${MAX_THREADS:-"100"}