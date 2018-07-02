#!/bin/bash

# Use this file to update the ssl certificate
# You must stop haproxy with `sudo service haproxy stop` before running this script
# TODO : Change the http port and proxy requests to a local web server to update certificates without downtime

DOMAIN='example.com'
EMAIL='tech@eosdac.io'

sudo certbot certonly --standalone  --non-interactive --agree-tos --email $EMAIL --http-01-port 1977 -d $DOMAIN
sudo -E bash -c "cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem"

