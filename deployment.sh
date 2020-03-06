# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    deployment.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/06 12:09:02 by asolopov          #+#    #+#              #
#    Updated: 2020/03/06 16:01:57 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

RES='\e[0m'
GREEN='\e[0;32m'

source deployment.conf
script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"

error_exit() {
	echo -e "Error, exit"
	exit
}

echo -e "${GREEN}-----Creating New User-----${RES}"
bash srcs/create_user.sh $USER_NAME || error_exit

echo -e "${GREEN}-----Updating system-----${RES}"
bash srcs/update_packages.sh || error_exit
echo -e "${GREEN}-----Done-----${RES}"

declare -a packages=(
	"vim"
	"ufw"
	"fail2ban"
	"postfix"
	"mailutils"
	"apache2"
)

for p in ${packages[@]}; do
	echo -e "${GREEN}-----Installing package "$p"-----${RES}"
	apt-get install -y $p || error_exit
done
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Copying interfaces-----${RES}"
cp srcs/interfaces /etc/network || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Copying sshd_config-----${RES}"
cp srcs/interfaces /etc/ssh || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Adding public key-----${RES}"
cat srcs/id_rsa.pub > /home/$USER_NAME/.ssh/authorized_keys || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Restarting networking and ssh-----${RES}"
systemctl restart networking || error_exit
systemctl restart sshd || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Printing networking and ssh status-----${RES}"
systemctl status networking --no-pager || error_exit
systemctl status sshd --no-pager || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Enabling ufw-----${RES}"
ufw enable
echo -e "${GREEN}-----Done-----${RES}"

declare -a ufw_allow=(
	"${SSH_PORT}/tcp"
	"80/tcp"
	"443"
)

for x in "${ufw_allow[@]}"; do
	echo -e "${GREEN}-----Allowing "$x"-----${RES}"
	ufw allow "$x" || error_exit
done
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----ufw status-----${RES}"
ufw status verbose || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Updating jail.conf-----${RES}"
cp srcs/jail.local /etc/fail2ban || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Adding filters-----${RES}"
cp srcs/http-get-dos.conf /etc/fail2ban/filter.d || error_exit
cp srcs/port-ban-hammer.conf /etc/fail2ban/filter.d || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Restarting fail2ban-----${RES}"
systemctl restart fail2ban || error_exit
echo -e "${GREEN}-----Done-----${RES}"

declare -a disable_service=(
	"keyboard-setup.service"
	"console-setup.service"
)
for y in "${disable_service[@]}"; do
	echo -e "${GREEN}-----Disabling "$y"-----${RES}"
	systemctl stop ${y} || error_exit
	systemctl disable ${y} || error_exit
done
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Setting up crontab-----${RES}"
echo -e "${GREEN}----------Save md5sum of cron-----${RES}"
md5sum /var/spool/cron/crontabs/root > md5sum || error_exit
echo -e "${GREEN}----------Done-----${RES}"
echo -e "${GREEN}----------Copy cronfiles to home-----${RES}"
cp /home/$USER_NAME/deploy/md5sum /home || error_exit
cp /home/$USER_NAME/deploy/root /home || error_exit
cp /home/$USER_NAME/deploy/srcs/compare_cron.sh /home || error_exit
cp /home/$USER_NAME/deploy/srcs/update_packages.sh /home || error_exit
echo -e "${GREEN}----------Done-----${RES}"
echo -e "${GREEN}----------Apply cron file-----${RES}"
cp /home/root /var/spool/cron/crontab || error_exit
echo -e "${GREEN}----------Done-----${RES}"