FROM solr:7.2-alpine

ENV SOLR_HOME=/solr_data \
    SOLR_CONFIG=/solr_config


# NB: The following mkdir/chown commands are required. Docker volumes are mounted as root, unless they have pre-existing
# permissions. The Solr server runs as the solr user (not root), and thus cannot write to a mounted volume - except if it
# has been initialised with solr permissions.

USER root
RUN mkdir -p $SOLR_HOME $SOLR_CONFIG \
    && chown -R $SOLR_USER:$SOLR_GROUP $SOLR_HOME $SOLR_CONFIG


##########


USER $SOLR_USER
ADD config/ $SOLR_CONFIG
ADD docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d
