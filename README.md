# Roger-skyline-1
## Initiation project to system and network administration.

This project follows Init where I have learned some of the basic commands and first reflexes in system and network administration. This one will be a concrete example on the use of those commands to start my first own web server.

### V.1 VM Part

I've set up a Debian virtual machine on Virtual Box hypervisor.
The version of Debian used for the project: Debian 10.3.0 AMD64

It has the following properties:
* Disk size of 8 GB
* Has a 4.2 GB partition

Software installed:
* web server
* print server
* SSH server
* standard system utilities

### V.2 Network and Security Part

>You must create a non-root user to connect to the machine and work.
>Use sudo, with this user, to be able to perform operation requiring special rights.

A script *create_user.sh* takes a USERNAME as a parameter, creates a new user, prompts to add user to sudoers file, prompts to relogin.

>We don’t want you to use the DHCP service of your machine. You’ve got to configure it to have a static IP and a Netmask in \30.

I configured static IP by modifying */etc/network/interfaces* configuration file as follows:
```
auto enp0s3
iface enp0s3 inet static
    address 10.12.107.111
    netmask 255.255.255.252
    gateway 10.12.254.254
```

>You have to change the default port of the SSH service by the one of your choice. SSH access HAS TO be done with publickeys. SSH root access SHOULD NOT be allowed directly, but with a user who can be root.

The port of the SSH service and root access are configured in */etc/ssh/sshd_config* file:
```
Port 50110
PermitRootLogin no
```

To SSH with publickey, I've created a key on a machine I will connect from by:
```ssh-keygen -t rsa*```

I then copied the keyfile via scp:
```scp -P 50110 /Users/asolopov/.ssh/id_rsa.pub asolopov@10.12.107.111:/home/asolopov/```

On the virtual machine I've created the *authorized_keys* file:
```mkdir -p ~/.ssh touch ~/.ssh/authorized_keys```

Lastly, I've copied the key to the file:
```cat ~/id_rsa.pub >> ~/.ssh/authorized_keys```

Voilà! You can now ssh as asolopov without a password!

>You have to set the rules of your firewall on your server only with the services used outside the VM.

I have installed the ufw (uncomplicated firewall):
```sudo apt install ufw```

I then added the following rules:

```sudo ufw allow 50110/tcp``` to allow incoming SSH connection to the port.

```sudo ufw allow 80/tcp``` to allow incoming HTTP connections.

```sudo ufw allow 443/tcp``` to allow incoming HTTPS connections.

All other incoming connections are denied, and all outgoing connections are allowed.

>You have to set a DOS (Denial Of Service Attack) protection on your open ports of your VM.

I've installed Fail2Ban package: ```sudo apt install fail2ban```

I then navigated to: ```/etc/fail2ban/```

I've created copies of: ```fail2ban.conf > fail2ban.local && jails.conf > jails.local```

* Banning SSH

I modified the *jails.local* file by adding to JAILS, [sshd]:
```
mode = normal
enabled = true
port = 50110
banaction = iptables-multiport"
```

After restarting fail2ban service, I've tried connecting via SSH and passing incorrect password, which resulted in IP ban after permission to connect was denied.

To unban the IP I used: ```sudo fail2ban-client set sshd unbanip 10.12.1.6``` on the VM.

* Banning HTTP

I modified the *jails.local* file by adding a new jail to JAILS, [http-get-dos]:
```
[http-get-dos]
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/apache2/access.log
maxretry = 200
findtime = 200
bantime = 600
action = iptables[name=HTTP, port=http, protocol=tcp]
```

I then created a filter file *http-get-dos.conf* in: ```/etc/fail2ban/filter.d/```
```
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*
ignoreregex =
```

After restarting fail2ban service, I've tried to Slowloris DOS at 10.12.107.111:80, which resulted in IP ban.

To unban the IP I used: ```sudo fail2ban-client set http-get-dos unbanip 10.12.1.6``` on the VM.

>You have to set a protection against scans on your VM’s open ports.

### VI.1 Web Part

### VI.2 Deployment Part
