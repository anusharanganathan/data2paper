FROM tomcat:9-alpine

# There are different ENV vars to consider when running Fedora Commons.
# An explanation of running Tomcat from https://stackoverflow.com/a/29398713/1154882

# "
# In many circumstances, it is desirable to have a single copy of a Tomcat binary distribution shared among multiple users on the same server. To make this possible, you can set the CATALINA_BASE environment variable to the directory that contains the files for your 'personal' Tomcat instance.

# When running with a separate CATALINA_HOME and CATALINA_BASE, the files and directories are split as following:

# In CATALINA_BASE:
#   bin - Only: setenv.sh (*nix) or setenv.bat (Windows), tomcat-juli.jar
#   conf - Server configuration files (including server.xml)
#   lib - Libraries and classes, as explained below
#   logs - Log and output files
#   webapps - Automatically loaded web applications
#   work - Temporary working directories for web applications
#   temp - Directory used by the JVM for temporary files>

# In CATALINA_HOME:
#   bin - Startup and shutdown scripts
#   lib - Libraries and classes, as explained below
#   endorsed - Libraries that override standard "Endorsed Standards". By default it's absent.
# "

# In this configuration:
# CATALINA_HOME is set by the Tomcat Docker image. There should be no need to change it.
# CATALINA_BASE is the directory where settings specific to the Fedora Commons app need to be held.

# Certain directories in CATALINA_BASE hold static files (e.g. bin, conf, lib), whereas other directories change during
# runtime (e.g. logs, webapps, work, temp).
# The static directories should be baked into the image. The writeable directories should be mounted as volumes.
# In this case this would result in 3 extra volumes, none of which are particularly useful.

# For this setup, it is easier to make the entire CATALINA_BASE (APP_HOME) a volume. That means that when the volume is mounted at container
# start-up, everything done inside CATALINA_BASE in this Dockerfile is going to disappear (unless it's being run on a
# local developer workstation). All actions that need to be taken inside CATALINA_BASE should be performed in the
# docker-entrypoint.sh file, not in this Dockerfile.

# What we do here is to add all static assets to a static directory, FEDORA_CONTAINER_DIR. Those will be symlinked
# into CATALINA_BASE by docker-entrypoint.sh on container start-up.

# The final result after the container starts is:
# ls -l $CATALINA_BASE
#   bin -> $FEDORA_CONTAINER_DIR/bin
#   conf -> $FEDORA_CONTAINER_DIR/conf
#   logs
#   webapps
#     ROOT.war -> $FEDORA_CONTAINER_DIR/webapps/ROOT.war
#   work
#   temp

ARG APP_NAME=fedora_commons
ARG FEDORA_COMMONS_URL=https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.7.2/fcrepo-webapp-4.7.2.war


# $APP_HOME is a volume, to be mounted in the docker-compose file at /fedora_commons/home
# $APP_DATA is a volume, to be mounted in the docker-compose file at /fedora_commons/data
# $APP_STATIC is not a volume and is built here. It should not contain changing files.

# Note that: $APP_HOME == $FCREPO4_HOME == $CATALINA_BASE


ENV APP_NAME="$APP_NAME" \
    APP_STATIC="/$APP_NAME/static" \
    APP_HOME="/$APP_NAME/home" \
    APP_DATA="/$APP_NAME/data"


ENV CATALINA_BASE=$APP_HOME \
    FCREPO4_HOME=$APP_HOME \
    FCREPO4_DATA=$APP_DATA

RUN mkdir -p \
        $APP_STATIC \
        $APP_STATIC/bin \
        $APP_STATIC/webapps \
        $APP_HOME \
        $APP_DATA \
        /tmp



# Tip: downloading large files with "curl -L <URL> -o <file>" (rather than with DOCKER ADD) allows for the files to be fully cached
RUN apk add --no-cache \
    curl \
    postgresql-client \
    && curl -L $FEDORA_COMMONS_URL -o $APP_STATIC/webapps/ROOT.war

COPY conf $APP_STATIC/conf
COPY bin/setenv.sh $APP_STATIC/bin/setenv.sh
COPY bin/docker-entrypoint.sh bin/docker-healthcheck.sh bin/wait_for_postgres.sh /bin/


ENTRYPOINT ["/bin/docker-entrypoint.sh"]

HEALTHCHECK --interval=5m CMD ["/bin/docker-healthcheck.sh"]
