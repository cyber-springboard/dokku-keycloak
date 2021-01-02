# Deploy Keycloak to Dokku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity and Access Manangement Solution 
to Dokku.  It is based of Keycloak's official docker image with some slight modifications to use the
Heroku variable for `PORT` and `DATABASE_URL` properly.
