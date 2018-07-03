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
systemctl status syncthing@<username>.service
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

Change the `syncthing` configuration to run on the trusted interface.

```console
cd ~/.config/syncthing
nano config.xml
```

Your local device elemet will look something like this:

```console
    <device id="KLK6CZT-63TKZER-COX5RZV-JMDIJXC-BBS24VJ-FZB7MBJ-GGQX7IN-CRFU5AF" name="ip-172-31-44-198" compression="metadata" introducer="false" skipIntroductionRemovals="false" introducedBy="">
        <address>dynamic</address>
        <paused>false</paused>
    </device>
```

Change the `name` setting to the desired name for your device.

Change the `address` setting to `tcp://<Wireguard-IP-address>:<port>`. You can leave out `:<port>` if you are hosting the service on the default port (22000).

You can also add the `allowedNetwork` setting. For the trusted network, this will look like this: `<allowedNetwork>172.16.0.0/12</allowedNetwork>`

Given this value, `syncthing` will:
- Allow connections from the device from addresses in the specified networks.
- Reject connections from the device from addresses outside the specified networks.
- Attempt connections to addresses in the specified networks (manually configured or discovered).
- Not attempt connections to addresses outside the specified networks, regardless of whether manually configured or automatically discovered.

After making these changes, the device element should look something like this:

```console
    <device id="KLK6CZT-63TKZER-COX5RZV-JMDIJXC-BBS24VJ-FZB7MBJ-GGQX7IN-CRFU5AF" name="jae-fn-1" compression="metadata" introducer="false" skipIntroductionRemovals="false" introducedBy="">
        <address>tcp://172.16.0.14</address>
        <paused>false</paused>
        <allowedNetwork>172.16.0.0/12</allowedNetwork>
    </device>
```

### Adding devices

When adding more devices, you need to know the `device id` and `address`. Therefore, if I wanted the Swedish guy to add me as a "peer", I would send him my `device id`, `KLK6CZT-63TKZER-COX5RZV-JMDIJXC-BBS24VJ-FZB7MBJ-GGQX7IN-CRFU5AF`, and my `address`, `tcp://172.16.0.14` (no need to port since I'm using the default 22000). Then, he would add a `device` element for my node using the information.

Some useful settings to consider adding:
- `introducer`: Set to true if this device should be trusted as an introducer. Example: Local device L sets remote device I as an introducer. They share the folder “Pictures”. Device I is sharing the folder with A and B, but L only shares with I. Once L and I connect, L will add A and B automatically. Remote device I also shares “Videos” with device C, but not with our local L. Device C will not be added to L as it is not connected to any folders that L and I share.
- `paused`: True if synchronization with this devices is (temporarily) suspended.
