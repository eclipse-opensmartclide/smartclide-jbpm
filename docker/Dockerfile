FROM jboss/jbpm-server-full:7.56.0.Final

LABEL org.opencontainers.image.authors="smartclide@atb-bremen.de"

# install keycloak-wildfly-adapter
ENV KEYCLOAK_VERSION 14.0.0
RUN curl -L -o ${JBOSS_HOME}/keycloak-oidc-wildfly-adapter.zip https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-oidc-wildfly-adapter-${KEYCLOAK_VERSION}.zip && \
    unzip -o -q ${JBOSS_HOME}/keycloak-oidc-wildfly-adapter.zip -d ${JBOSS_HOME} && \
    rm -rf ${JBOSS_HOME}/keycloak-oidc-wildfly-adapter.zip
RUN ${JBOSS_HOME}/bin/jboss-cli.sh --file=${JBOSS_HOME}/bin/adapter-elytron-install-offline.cli

# remove superfluous war
RUN rm ${JBOSS_HOME}/standalone/deployments/jbpm-casemgmt.war

# patch business-central war
ADD business-central/web.xml ${JBOSS_HOME}/standalone/deployments/WEB-INF/web.xml

USER root
RUN chown -R jboss:jboss ${JBOSS_HOME}/standalone/deployments/WEB-INF
USER jboss

RUN jar ufv ${JBOSS_HOME}/standalone/deployments/business-central.war -C ${JBOSS_HOME}/standalone/deployments WEB-INF && \
    rm -rf ${JBOSS_HOME}/standalone/deployments/WEB-INF

# remove superfluous files
RUN rm ${JBOSS_HOME}/standalone/configuration/users.properties && \
    rm ${JBOSS_HOME}/standalone/configuration/roles.properties

# update scripts and configuration
ADD bin/jbpm-postgres-config.cli ${JBOSS_HOME}/bin/jbpm-postgres-config.cli
ADD bin/update_config.sh ${JBOSS_HOME}/bin/update_config.sh
ADD bin/start_jbpm-wb.sh ${JBOSS_HOME}/bin/start_jbpm-wb.sh
ADD configuration/standalone.xml ${JBOSS_HOME}/standalone/configuration/standalone.xml

USER root

RUN chown jboss:jboss ${JBOSS_HOME}/bin/jbpm-postgres-config.cli
RUN chown jboss:jboss ${JBOSS_HOME}/bin/update_config.sh
RUN chown jboss:jboss ${JBOSS_HOME}/bin/start_jbpm-wb.sh
RUN chown jboss:jboss ${JBOSS_HOME}/standalone/configuration/standalone.xml

# switch back to jboss user
USER jboss
