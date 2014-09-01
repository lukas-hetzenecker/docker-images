#!/usr/bin/env bash

set -e # Exit on errors

echo "-> Starting Bamboo Agent ..."
echo "   - BAMBOO_VERSION: $BAMBOO_VERSION"
echo "   - BAMBOO_HOME:    $BAMBOO_HOME"

mkdir -p $BAMBOO_HOME

if [[ $SERVER_ID && $LICENSE_KEY && $DB_TYPE && $DB_DRIVER && $DB_DIALECT && $DB_HOST && $DB_USER && $DB_PASS && $DB_DATABASE ]]; then
  if [ ! -f $BAMBOO_HOME/bamboo.cfg.xml ]; then
    cp /etc/bamboo.cfg.xml.new $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='hibernate.connection.driver_class']" -v $DB_DRIVER $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='hibernate.dialect']" -v $DB_DIALECT $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='hibernate.connection.url']" -v jdbc:$DB_TYPE://$DB_HOST:/$DB_DATABASE $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='hibernate.connection.username']" -v $DB_USER $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='hibernate.connection.password']" -v $DB_PASS $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='serverId']" -v $SERVER_ID $BAMBOO_HOME/bamboo.cfg.xml
    xmlstarlet ed --inplace --update "/application-configuration/properties/property[@name='license.string']" -v $LICENSE_KEY $BAMBOO_HOME/bamboo.cfg.xml
  fi
fi

BAMBOO_DIR=/opt/atlassian-bamboo-$BAMBOO_VERSION

if [ -d $BAMBOO_DIR ]; then
  echo "-> Bamboo $BAMBOO_VERSION already found at $BAMBOO_DIR. Skipping download."
else
  BAMBOO_TARBALL_URL=http://downloads.atlassian.com/software/bamboo/downloads/atlassian-bamboo-$BAMBOO_VERSION.tar.gz
  echo "-> Downloading Bamboo $BAMBOO_VERSION from $BAMBOO_TARBALL_URL ..."
  wget --progress=dot:mega $BAMBOO_TARBALL_URL -O /tmp/atlassian-bamboo.tar.gz
  echo "-> Extracting to $BAMBOO_DIR ..."
  tar xzf /tmp/atlassian-bamboo.tar.gz -C /opt
  rm -f /tmp/atlassian-bamboo.tar.gz
  echo "-> Installation completed"
fi

# Uncomment to increase Tomcat's maximum heap allocation
# export JAVA_OPTS=-Xmx512M $JAVA_OPTS

echo "-> Running Bamboo server ..."
$BAMBOO_DIR/bin/catalina.sh run &

# Kill Bamboo process on signals from supervisor
trap 'kill $(jobs -p)' SIGINT SIGTERM EXIT

# Wait for Bamboo process to terminate
wait $(jobs -p)
