# Deploy Keycloak to Dokku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity and Access Manangement Solution 
to Dokku.  It is based of Keycloak's official docker image with some slight modifications to use the
Heroku variable for `PORT` and `DATABASE_URL` properly.

The key to get Keycloak working on Dokku is configure Nginx correctly. You need to add a custom Nginx configuration to the Docker image that will listen on port 80. Then let [dokku-letsencrypt](https://github.com/dokku/dokku-letsencrypt) generate the certificates and add the SSL mapping.

Also you need to fix the docker internal IP address, you can obtain one by running `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id`