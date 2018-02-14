#!/bin/bash

# See the associated Fedora Commons Dockerfile for an explanation of important environment variables.

set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

ln -sf $APP_CONTAINER/bin $APP_LOCAL_VOLUME/
ln -sf $APP_CONTAINER/conf $APP_LOCAL_VOLUME/
ln -sf $APP_CONTAINER/lib $APP_LOCAL_VOLUME/



mkdir -p $APP_LOCAL_VOLUME/logs $APP_LOCAL_VOLUME/webapps $APP_LOCAL_VOLUME/work $APP_LOCAL_VOLUME/temp

ln -sf $APP_CONTAINER/webapps/ROOT.war $APP_LOCAL_VOLUME/webapps/ROOT.war



# start TomCat in foreground mode
catalina.sh run
