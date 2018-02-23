#!/bin/bash

echo "Booting $APP_NAME Puma in $APP_WORKDIR ($RAILS_ENV)"


# Create log and tmp folders
mkdir -p $APP_WORKDIR/log /tmp

if [ "$RAILS_ENV" = "production" ]; then
    # Verify all the production gems are installed
    bundle check
else
    # install any missing development gems (as we can tweak the development container without rebuilding it)
    bundle check || bundle install --without production
fi

# Wait for Postgres
./bin/wait_for_postgres.sh

# Wait for Solr
./bin/wait_for_solr.sh

# Wait for Fedora
./bin/wait_for_fedora.sh


# ^^^ Ensure Postgres, Solr and Fedora are running before proceeding


# Run any pending migrations
bundle exec rake db:migrate

setup_initialised=/setup/setup_initialised
if [ -f $setup_initialised ] ; then
    echo "skipping setup initialisation"
else
    # Create default admin set and workflows
    bundle exec rails hyrax:default_admin_set:create hyrax:workflow:load

    # Create admin user
    bundle exec rake users:create_admin_user["${ADMIN_EMAIL:-admin@example.com}","${ADMIN_PASSWORD:-password}"]

    # Set hyrax features
    bundle exec rake features:set["show_deposit_agreement:false","active_deposit_agreement_acceptance:false","assign_admin_set:false","batch_upload:false"]

    touch $setup_initialised
fi




# clear old pid, state and socket files
rm -f /tmp/puma.pid /tmp/puma.state /tmp/puma.sock

echo "--------- Starting $APP_NAME Puma in $RAILS_ENV mode ---------"
bundle exec puma
