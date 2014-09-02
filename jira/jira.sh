#!/usr/bin/env bash

. /opt/scripts/common.bash

set -e # Exit on errors

echo "-> Starting Jira ..."
echo "   - JIRA_VERSION: $JIRA_VERSION"
echo "   - JIRA_HOME:    $JIRA_HOME"

if [ -z "$JIRA_HOME" ]; then
  export JIRA_HOME=/opt/atlassian-home
fi

JIRA_DIR=/opt/atlassian-jira-$JIRA_VERSION
if [ -d $JIRA_DIR ]; then
  echo "-> Jira $JIRA_VERSION already found at $JIRA_DIR. Skipping download."
else
  JIRA_TARBALL_URL=http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-$JIRA_VERSION.tar.gz
  echo "-> Downloading Jira $JIRA_VERSION from $JIRA_TARBALL_URL ..."
  wget --progress=dot:mega $JIRA_TARBALL_URL -O /tmp/atlassian-jira.tar.gz
  echo "-> Extracting to $JIRA_DIR ..."
  tar xzf /tmp/atlassian-jira.tar.gz -C /opt
  rm -f /tmp/atlassian-jira.tar.gz
  echo "-> Installation completed"
fi

if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
  CONTEXT_PATH=
else
  echo "Setting context path to: $CONTEXT_PATH"
  CONTEXT_PATH="/$CONTEXT_PATH"
fi
xmlstarlet ed --inplace --update '//Context/@path' -v "$CONTEXT_PATH" $JIRA_DIR/conf/server.xml

mkdir -p $JIRA_HOME

if [ -n "$DATABASE_URL" ]; then
  extract_database_url "$DATABASE_URL" DB $JIRA_HOME/lib
  DB_JDBC_URL="$(xmlstarlet esc "$DB_JDBC_URL")"

  cat << EOF > $JIRA_HOME/dbconfig.xml
<?xml version="1.0" encoding="UTF-8"?>
<jira-database-config>
  <name>defaultDS</name>
  <delegator-name>default</delegator-name>
  <database-type>$DB_TYPE</database-type>
  <schema-name>public</schema-name>
  <jdbc-datasource>
    <url>$DB_JDBC_URL</url>
    <driver-class>$DB_JDBC_DRIVER</driver-class>
    <username>$DB_USER</username>
    <password>$DB_PASSWORD</password>
    <pool-min-size>20</pool-min-size>
    <pool-max-size>20</pool-max-size>
    <pool-max-wait>30000</pool-max-wait>
    <pool-max-idle>20</pool-max-idle>
    <pool-remove-abandoned>true</pool-remove-abandoned>
    <pool-remove-abandoned-timeout>300</pool-remove-abandoned-timeout>
  </jdbc-datasource>
</jira-database-config>
END
EOF

fi

echo "-> Running Jira server ..."
$JIRA_DIR/bin/start-jira.sh -fg

