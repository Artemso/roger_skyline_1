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

### VI.1 Web Part

### VI.2 Deployment Part