#!/bin/bash

# See the associated Fedora Commons Dockerfile for an explanation of important environment variables.

set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi


# For this setup, it is easier to make the entire CATALINA_BASE a volume. That means that when the volume is mounted at container
# start-up, everything done inside CATALINA_BASE in this Dockerfile is going to disappear (unless it's being run on a
# local developer workstation). All actions that need to be taken inside CATALINA_BASE should be performed in this file.

ln -sf $APP_STATIC/bin $APP_HOME/
ln -sf $APP_STATIC/conf $APP_HOME/


mkdir -p $APP_HOME/logs $APP_HOME/webapps $APP_HOME/work $APP_HOME/temp

ln -sf $APP_STATIC/webapps/ROOT.war $APP_HOME/webapps/ROOT.war

# Wait for Postgres
wait_for_postgres.sh


# start TomCat in foreground mode
catalina.sh run
