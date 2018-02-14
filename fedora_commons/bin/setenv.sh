#! /bin/sh
# See the associated Fedora Commons Dockerfile for an explanation of important environment variables.

# Options as recommended at https://wiki.duraspace.org/display/FEDORA4X/Java+HotSpot+VM+Options+recommendations
export CATALINA_OPTS="$CATALINA_OPTS -Djava.awt.headless=true"
export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
export CATALINA_OPTS="$CATALINA_OPTS -server"
export CATALINA_OPTS="$CATALINA_OPTS -Xms1024m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx2048m"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxMetaspaceSize=512m"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"

export CATALINA_OPTS="$CATALINA_OPTS -Dfcrepo.modeshape.configuration=classpath:/config/jdbc-postgresql/repository.json"
export CATALINA_OPTS="$CATALINA_OPTS -Dfcrepo.postgresql.host=${POSTGRES_HOST}"
export CATALINA_OPTS="$CATALINA_OPTS -Dfcrepo.postgresql.port=${POSTGRES_PORT:-5432}"
export CATALINA_OPTS="$CATALINA_OPTS -Dfcrepo.postgresql.username=${POSTGRES_USER}"
export CATALINA_OPTS="$CATALINA_OPTS -Dfcrepo.postgresql.password=${POSTGRES_PASSWORD}"
export CATALINA_OPTS="$CATALINA_OPTS -Dfcrepo.home=${FCREPO4_DATA}"

export JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom"


echo "Using CATALINA_OPTS:"
for arg in $CATALINA_OPTS
do
    echo ">> " $arg
done
echo ""

echo "Using JAVA_OPTS:"
for arg in $JAVA_OPTS
do
    echo ">> " $arg
done
echo "_______________________________________________"
echo ""
