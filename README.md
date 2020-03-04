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

auto enp0s3
iface enp0s3 inet static
        address 10.12.107.111
        netmask 255.255.255.252
        gateway 10.12.254.254
### VI.1 Web Part

### VI.2 Deployment Part