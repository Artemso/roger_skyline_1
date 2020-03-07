# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    deployment.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/06 12:09:02 by asolopov          #+#    #+#              #
#    Updated: 2020/03/07 16:35:38 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

RES='\e[0m'
GREEN='\e[0;32m'

source deployment.conf

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
cp srcs/sshd_config /etc/ssh || error_exit
echo -e "${GREEN}-----Done-----${RES}"

key_file=/home/$USER_NAME/.ssh/authorized_keys
echo -e "${GREEN}-----Adding public key-----${RES}"
if [ -f "$key_file" ];
then
	cat srcs/id_rsa.pub > /home/$USER_NAME/.ssh/authorized_keys || error_exit
else
	mkdir /home/$USER_NAME/.ssh
	touch /home/$USER_NAME/.ssh/authorized_keys || error_exit
	cat srcs/id_rsa.pub > /home/$USER_NAME/.ssh/authorized_keys || error_exit
fi
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
sudo ufw logging high
sudo ufw --force enable
echo -e "${GREEN}-----Done-----${RES}"

declare -a ufw_allow=(
	"${SSH_PORT}/tcp"
	"80/tcp"
	"443"
)

for x in "${ufw_allow[@]}"; do
	echo -e "${GREEN}-----Allowing "$x"-----${RES}"
	sudo ufw allow "$x" || error_exit
done
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----ufw status-----${RES}"
ufw status verbose || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Updating jail.conf-----${RES}"
cp srcs/jail.local /etc/fail2ban || error_exit
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local || error_exit
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
echo -e "${GREEN}----------Copy cronfiles to home${RES}"
cp srcs/root /home || error_exit
cp srcs/compare_cron.sh /home || error_exit
cp srcs/update_packages.sh /home || error_exit
cp srcs/update_html.sh /home || error_exit
cp srcs/mailbody /home || error_exit
echo -e "${GREEN}----------Done${RES}"
echo -e "${GREEN}----------Apply cron file${RES}"
cp /home/root /var/spool/cron/crontabs/ || error_exit
echo -e "${GREEN}----------Save md5sum of cron${RES}"
md5sum /var/spool/cron/crontabs/root > md5sum || error_exit
cp md5sum /home || error_exit
echo -e "${GREEN}----------Done${RES}"
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Deploying Website-----${RES}"
cp srcs/index.html /var/www/html || error_exit
cp srcs/doggie_banana.jpg /var/www/html || error_exit

md5sum /var/www/html/index.html > /home/html_md5 || error_exit
echo -e "${GREEN}-----Done-----${RES}"

echo -e "${GREEN}-----Setting UP SSL-----${RES}"
echo -e "${GREEN}----------Generating key and certificate${RES}"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=FI/ST=/L=/O=/OU=/CN=${IP_ADDRESS}" \
	-keyout /etc/ssl/private/apache-selfsigned.key \
	-out /etc/ssl/certs/apache-selfsigned.crt || error_exit
echo -e "${GREEN}----------Done${RES}"
echo -e "${GREEN}----------Copy ssl settings${RES}"
cp srcs/ssl-params.conf /etc/apache2/conf-available/ || error_exit
cp srcs/default-ssl.conf /etc/apache2/sites-available/ || error_exit
cp srcs/000-default.conf /etc/apache2/sites-available/ || error_exit
echo -e "${GREEN}----------Done${RES}"
echo -e "${GREEN}----------Apply SSL changes${RES}"
a2enmod ssl
a2enmod headers
a2ensite default-ssl
a2enconf ssl-params
apache2ctl configtest
echo -e "${GREEN}----------Done${RES}"
echo -e "${GREEN}-----Done-----${RES}"
echo -e "${GREEN}-----Restarting all services-----${RES}"
systemctl restart networking
systemctl restart ufw
systemctl restart fail2ban
systemctl restart apache2
systemctl restart sshd
echo -e "${GREEN}-----Done-----${RES}"