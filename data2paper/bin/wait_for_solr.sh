#!/bin/bash

if [ "$RAILS_ENV" = "production" ]; then
    SOLR_BASE_URL=$(echo "$SOLR_PRODUCTION_URL" | cut -d'/' -f1,2,3)
else
    SOLR_BASE_URL=$(echo "$SOLR_DEVELOPMENT_URL" | cut -d'/' -f1,2,3)
fi

# Wait for Solr
until [ -n "$SOLR" ] ; do
    SOLR=$(wget -qO- "$SOLR_BASE_URL" | grep "Apache SOLR")
    if [ -z "$SOLR" ] ; then
        echo "Waiting for Solr server on $SOLR_BASE_URL"
        sleep 2
    fi
done
