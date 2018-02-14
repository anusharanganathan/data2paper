FROM ruby:2.4.2-slim
# use Slim to reduce image size (consider Alpine in the future)

# Set application name and FITS version
ARG APP_NAME=data2paper
ARG FITS_URL=http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip


# Set up initial environmental variables
# Default to UTF-8 file.encoding
# see https://bugs.debian.org/775775 and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre \
    RAILS_LOG_TO_STDOUT=yes_please \
    BUNDLE_JOBS=2 \
    APP_NAME="$APP_NAME" \
    APP_CONTAINER=/$APP_NAME/container/ \
    APP_LOCAL_MOUNTED=/$APP_NAME/local_mounted/ \
    PATH="$PATH:/opt/fits"

# Add backports to apt-get sources
# Install libraries, dependencies, java and fits
RUN echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libpq-dev \
    postgresql-client \
    libxml2-dev libxslt-dev \
    libqt4-webkit libqt4-dev xvfb \
    nodejs \
    imagemagick \
    libreoffice \
    ghostscript \
    ffmpeg \
    ufraw \
    bzip2 unzip xz-utils wget rename file \
    # install open-jdk and ca-certs from jessie-backports
    && apt-get install -t jessie-backports -y --no-install-recommends openjdk-8-jre-headless ca-certificates-java \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && /var/lib/dpkg/info/ca-certificates-java.postinst configure \
    && mkdir -p /tmp/ \
    && wget -q $FITS_URL -O /tmp/fits.zip \
    && unzip -q /tmp/fits.zip -d /tmp/ \
    && rm /tmp/fits.zip \
    && rename 's/fits\-.*/fits/' /tmp/fits-* \
    && mv /tmp/fits/ /opt/fits/ \
    && chmod a+x /opt/fits/fits.sh \
    && mkdir -p $APP_CONTAINER \
    && mkdir -p $APP_LOCAL_MOUNTED


# Always install the gems in the container folder in production, to make subsequent RAILS_ENV / mode changes a little faster
COPY Gemfile Gemfile.lock $APP_CONTAINER
RUN cd $APP_CONTAINER \
    && RAILS_ENV=production bundle config systemlibs --use-system-libraries \
    && RAILS_ENV=production bundle install --quiet \
    && mv Gemfile.lock Gemfile.lock.built_by_docker



############################################
# APPLICATION MODE SETTINGS (keep these here to avoid re-installing all the software above)
ARG RAILS_ENV
ARG APP_MODE
############################################


# keep these ENV settings below main software install above
ENV APP_WORKDIR="/$APP_NAME/$APP_MODE" \
    RAILS_ENV="$RAILS_ENV"


# install the development gems to system if required
RUN if [ "$RAILS_ENV" = "development" ]; then \
        cd $APP_CONTAINER \
        && mv Gemfile.lock.built_by_docker Gemfile.lock \
        && bundle install --quiet \
        && mv Gemfile.lock Gemfile.lock.built_by_docker; \
    fi


# copy the application to the container folder
COPY . $APP_CONTAINER

# use the just built Gemfile.lock, not the one copied into the container and verify the gems are correctly installed
RUN cd $APP_CONTAINER \
    && mv Gemfile.lock.built_by_docker Gemfile.lock \
    && bundle check

# generate production assets if production environment
RUN if [ "$RAILS_ENV" = "production" ]; then \
        cd $APP_CONTAINER \
        && SECRET_KEY_BASE=0 bundle exec rake assets:clean assets:precompile; \
    else \
        echo "Skipping asset compilation"; \
    fi

WORKDIR $APP_WORKDIR

CMD "$APP_WORKDIR/bin/puma.sh"
