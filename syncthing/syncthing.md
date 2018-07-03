# Syncthing setup for Ghostbusters

(For Ubuntu 16.04+)

This is also anti-GUI because of that Swedish guy. All complaints should be directed to him.

### Install

```console
# Install curl if it hasn't been installed yet
sudo apt-get install curl
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
```

If you see OK in the terminal, that means the GPG key is successfully imported. Then add official Syncthing deb repository with the following command.

```console
echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt-get update
sudo apt-get install syncthing
```

### Set up Syncthing as a `systemd` service

Run:
```console
sudo systemctl enable syncthing@<username>.service
```

You should get something like this:

```console
Created symlink from /etc/systemd/system/multi-user.target.wants/syncthing@linuxbabe.service to /lib/systemd/system/syncthing@.service.
```

Now run:
```console
sudo systemctl start syncthing@<username>.service
# Check status
systemctl status syncthing@username.service
```

You should now be able to find the `Sync` directory at its default location, `~/Sync`. 

It's great that it doesn't install itself in the root directory and requires you to write a relocate script to change the mount directory like some other application we've been using...

### Set Firewall rules

Using UFW, sorry Jem. Again, complaints can be sent directly to the Swedish guy.

```console
# Sync Protocol Listen Address
sudo ufw allow in on trusted proto tcp to any port 22000
# For discovery broadcasts on IPv4 and multicasts on IPv6
sudo ufw allow in on trusted proto udp to any port 21027
# Check that rules have been added correctly
sudo ufw status numbered
```

### Configuration

Run `syncthing -paths` if you want to see where all the `syncthing` related paths are.

With default settings, you should be able to find the configuration, crypto keys and index caches at `~/.config/syncthing`.

If you want to change the configurations, edit `config.xml` and restart `syncthing` service using `systemctl restart syncthing@ubuntu.service`
