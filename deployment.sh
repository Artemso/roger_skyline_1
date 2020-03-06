# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    deployment.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/06 12:09:02 by asolopov          #+#    #+#              #
#    Updated: 2020/03/06 12:52:09 by asolopov         ###   ########.fr        #
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

# echo -e "${GREEN}-----Updating system-----${RES}"
# bash srcs/update_packages.sh || error_exit
# echo -e "${GREEN}-----Done-----${RES}"

# declare -a packages=(
# 	"vim"
# 	"ufw"
# 	"fail2ban"
# 	"postfix"
# 	"mailutils"
# 	"apache2"
# )

# for p in ${packages[@]}; do
# 	echo -e "${GREEN}-----Installing package "$p"-----${RES}"
# 	apt-get install -y $p
# done
# echo -e "${GREEN}-----Done-----${RES}"

# echo -e "${GREEN}-----Copying interfaces-----${RES}"
# cp srcs/interfaces /etc/network
# echo -e "${GREEN}-----Done-----${RES}"

# echo -e "${GREEN}-----Copying sshd_config-----${RES}"
# cp srcs/interfaces /etc/ssh
# echo -e "${GREEN}-----Done-----${RES}"

# echo -e "${GREEN}-----Restarting networking and ssh-----${RES}"
# systemctl restart networking
# systemctl restart sshd
# echo -e "${GREEN}-----Done-----${RES}"

# echo -e "${GREEN}-----Printing networking and ssh status-----${RES}"
# systemctl status networking --no-pager
# systemctl status sshd --no-pager
# echo -e "${GREEN}-----Done-----${RES}"

# echo -e "${GREEN}-----Enabling ufw-----${RES}"
# ufw enable
# echo -e "${GREEN}-----Done-----${RES}"

declare -a ufw_allow=(
	"${SSH_PORT}/tcp"
	"80/tcp"
	"443"
)

for x in "${ufw_allow[@]}"; do
	echo -e "${GREEN}-----Allowing "$x"-----${RES}"
	ufw allow `echo ${e} | awk '{print $1}'`
done
echo -e "${GREEN}-----Done-----${RES}"