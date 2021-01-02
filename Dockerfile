FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools

ADD nginx.conf.sigil /

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

