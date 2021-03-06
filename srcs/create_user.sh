# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    create_user.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/02 19:13:28 by asolopov          #+#    #+#              #
#    Updated: 2020/03/04 12:06:49 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

GRN='\033[0;32m'
NC='\033[0m'

if [ "$1" != "" ]
then
	sudo adduser $1
	echo -e "${GRN}done${NC}"
	read -p "Make user "$1" sudo? (yes/y) `echo $'\n> '`" sudoprompt
	if [ "$sudoprompt" == "yes" ] || [ "$sudoprompt" == "y" ]
	then
		sudo adduser $1 sudo
		echo -e "${GRN}done${NC}"
		read -p "Would you like to exit and relogin? (yes/y) `echo $'\n> '`" restartprompt
		if [ "$restartprompt" == "yes" ] || [ "$restartprompt" == "y" ]
		then
			"$(whoami)" me
			sudo kill -9 `pgrep -f "$me"`
		fi
	fi
else
	echo "Usage: ./create_user.sh \"USERNAME\""
fi