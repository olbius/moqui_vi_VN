#!/bin/sh
set -e

if [ ! -z ${ELK_HOST} ]; then
    source elk.sh
fi


export PATH=$JAVA_HOME/bin:$PATH

java $JAVA_OPTS -jar /opt/moqui/moqui.war conf=/opt/moqui/runtime/conf/MoquiProductionConf.xml threads=${MAX_THREADS:-"100"}