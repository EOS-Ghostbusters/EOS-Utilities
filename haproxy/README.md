# Installing haproxy to load balance between full nodes

This folder contains information needed to set up haproxy as a load balancer for EOS full-nodes.  It also includes SSL termination and TLS certificate setup using letsencrypt

## haproxy installation

Modify the haproxy.cfg to suit your needs

_If this is the first time you are installing then comment the line which begins listen *:443_

```
sudo apt-get install
sudo cp haproxy.cfg /etc/haproxy/
sudo service haproxy reload
```

This should set up haproxy to relay requests to your node, next we will set up letsencrypt and install the certificate


```
sudo apt-get install certbot
```

Modify letsencrypt_new.sh to include your domain and email, then run it.  It should set up a server on port 1977 and then send a request to letsencrypt.  They will then call back to your server, validate the domain and then create your certificate

_That's it!_

### TODO : Renewals
