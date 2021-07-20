#!/usr/bin/env bash

echo "Update database connection setup"
./update_db_config.sh

echo "Update keycloak configuration"
./update_config.sh

echo "Running jBPM Server Full on JBoss Wildfly..."
exec ./standalone.sh \
    -b "$JBOSS_BIND_ADDRESS" \
    "$EXTRA_OPTS" \
    -Djava.net.preferIPv4Stack=true \
    -Djava.net.preferIPv4Addresses=true
exit $?
