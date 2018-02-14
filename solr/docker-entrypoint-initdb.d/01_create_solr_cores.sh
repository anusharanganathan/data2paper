#!/bin/bash
#
# SOLR_HOME = data folder (/solr_data), usually mounted as a volume
# SOLR_CONFIG = data folder (/solr_config), usually mounted as a volume

set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi


solr_created=$SOLR_HOME/solr_created

if [ -f $solr_created ] ; then
    echo "skipping solr core creation"
else
    cp /opt/solr/server/solr/solr.xml $SOLR_HOME/
    start-local-solr
    echo "Creating solr core(s)"
    /opt/solr/bin/solr create -c "data2paper" -d "$SOLR_CONFIG"
    /opt/solr/bin/solr create -c "data2paper-test" -d "$SOLR_CONFIG"
    touch $solr_created
    stop-local-solr
fi
