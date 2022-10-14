FROM quay.io/keycloak/keycloak:latest

COPY docker-entrypoint.sh /opt/keycloak/bin/

EXPOSE 80

ENTRYPOINT [ "/opt/keycloak/bin/docker-entrypoint.sh" ]
CMD ["/opt/keycloak/bin/docker-entrypoint.sh"]
