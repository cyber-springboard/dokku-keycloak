# Deploy Keycloak to Dokku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity
and Access Manangement Solution to Dokku.

It is based on Keycloak's official Quarkus docker image with modifications
to use Dokku's `DATABASE_URL` variable and enable [edge](https://github.com/keycloak/keycloak-community/blob/main/design/keycloak.x/configuration.md#proxy-mode)
proxy mode by default.

This runs the latest 19.x releases, combining approaches from [uesleilima/keycloak.x-heroku](https://github.com/uesleilima/keycloak.x-heroku) and [davidpodhola/keycloak-dokku](https://github.com/davidpodhola/keycloak-dokku).

## Prerequisites

The instructions and examples below are targeted at an audience looking to use Keycloak on a production(ish)
installation of Dokku requiring HTTPS with a properly signed certificate from [Let's Encrypt](https://letsencrypt.org/).

Where running commands on the Dokku host is referenced, you can make use of a local alias
to run the command remotely over SSH:

```bash
alias dokku='ssh -t user@example.com dokku'
```

### Dokku Installation Prerequisites

- A host with at least 2GB of RAM.
- [Dokku 0.24.7](https://dokku.com/docs~v0.24.7/getting-started/installation/) or greater installed.
- Dokku hostname configured to match the associated domain name.
  - The fake "example.com" will be used in examples below.

## Install Dokku Plugins

All of the commands in this section need to be **executed on the Dokku host machine**!

```bash
# PostgreSQL
dokku plugin:install https://github.com/dokku/dokku-postgres.git
# Let's Encrypt
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
```

## Create and Configure Keycloak App

All of the commands in this section need to be **executed on the Dokku host machine**!

You can name the Keycloak app and database anything you like, but for this example we'll
stick with "keycloak" to keep things simple.

```bash
# App settings
app="keycloak"
db="$app-db"
user="admin"
password="changeme"
hostname="keycloak.example.com" # Note: must match the DNS name used to access the instance

# Create app
dokku apps:create $app
dokku domains:set $app $hostname
dokku postgres:create $db
dokku postgres:link $db $app

# Configure keycloak
dokku config:set --no-restart $app KEYCLOAK_ADMIN=$user KEYCLOAK_ADMIN_PASSWORD=$password
dokku config:set --no-restart $app KEYCLOAK_HOSTNAME=$hostname
dokku config:set --no-restart $app KEYCLOAK_HTTP_PORT=80

# Configure port forwarding
dokku proxy:ports-add $app http:80:80
```

## Deploy Keycloak and Verify

### Deployment

All of the commands in this section need to be **executed on your development machine**!

Deployment can take a while the first time.

```bash
git clone https://github.com/cyber-springboard/dokku-keycloak.git
cd dokku-keycloak
git remote add dokku dokku@example.com:$app
git push dokku master
```

### Verify

All of the commands in this section need to be **executed on the Dokku host machine**!

```bash
dokku logs -t $app
```

### Enable HTTPS

All of the commands in this section need to be **executed on the Dokku host machine**!

Once the Keycloak deployment has completed, enable HTTPS using Let's Encrypt:

```bash
dokku config:set --no-restart $app DOKKU_LETSENCRYPT_EMAIL=user@example.com
dokku letsencrypt:enable $app

# Remove forwarding to port 5000
# TODO: Unsure why this is necessary
dokku proxy:ports-remove $app https:443:5000
```

### Login to Keycloak

Navigate to `https://keycloak.example.com/` and login with your admin credentials.
