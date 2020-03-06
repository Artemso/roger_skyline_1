# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    deployment.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/06 12:09:02 by asolopov          #+#    #+#              #
#    Updated: 2020/03/06 12:24:31 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

RES='\e[0m'
GREEN='\e[0;32m'

source deployment.conf

error_exit() {
	echo -e "Error, exit"
	exit
}

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
	echo -e "${GREEN}-----Installing packages-----${RES}"
	apt-get install -y $p
done
echo -e "${GREEN}-----Done-----${RES}"