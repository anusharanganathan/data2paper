#!/bin/bash

if [ "$RAILS_ENV" = "production" ]; then
    FEDORA_BASE_URL=$(echo "$FEDORA_PRODUCTION_URL" | cut -d'/' -f1,2,3,4)
else
    FEDORA_BASE_URL=$(echo "$FEDORA_DEVELOPMENT_URL" | cut -d'/' -f1,2,3,4)
fi


# Wait for Fedora
until [ -n "$FEDORA" ] ; do
    FEDORA=$(wget -qO- "$FEDORA_BASE_URL" | grep "Fedora Commons Repository")
    if [ -z "$FEDORA" ] ; then
        echo "Waiting for Fedora server on $FEDORA_BASE_URL"
        sleep 2
    fi
done
