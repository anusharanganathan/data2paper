#!/bin/bash

echo "Booting $APP_NAME Sidekiq in $APP_WORKDIR ($RAILS_ENV)"

# Create log and tmp folders
mkdir -p $APP_WORKDIR/log /tmp

# Wait for postgres to be available
./bin/wait_for_postgres.sh

# Wait for Solr
./bin/wait_for_solr.sh

# Wait for Fedora
./bin/wait_for_fedora.sh

echo "--------- Starting $APP_NAME SideKiq in $RAILS_ENV mode ---------"
bundle exec sidekiq
